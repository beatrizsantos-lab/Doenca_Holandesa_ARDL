# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx---------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# ANÁLISE ECONOMÉTRICA - Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: 
#                        Testando a Hipótese da Doença Holandesa
# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx---------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# O script a seguir visa investigar, via ARDL, a Doença Holandesa no Brasil (2022–2025), 
# testando se o boom de commodities, principalmente o pós-pandemia (2021-2025) apreciou 
# o câmbio e prejudicou a indústria e se houve quebra estrutural em relação aos anos 2000, 
# para Artigo de Econometria Aplicada do Programa de Pós-Graduação em Economia da UFAL.

# Autora: Beatriz Santos

# Data de Criação: 10/09/2025
# Última Modificação: 10/10/2025
# Versão: 5.0


# 1. CONFIGURAÇÃO DO AMBIENTE
# ------------------------------------------------------------------------------

# Instalação dos pacotes necessários
install.packages("tidyverse")
install.packages("lubridate")
install.packages("urca")
install.packages("ARDL")
install.packages("lmtest")
install.packages("sandwich")
install.packages("tseries")
install.packages("strucchange")
install.packages("car")

# Carregando os pacotes
library(tidyverse)
library(lubridate)
library(urca)
library(ARDL)
library(lmtest)
library(sandwich)
library(tseries)
library(strucchange)
library(car)
library(forcats)


# 1.1. CARREGAMENTO E LIMPEZA DOS DADOS
# ------------------------------------------------------------------------------

# Carregar os arquivos CSV. 
dados_pim <- read_csv2("PIM.csv") 
dados_icbr <- read_csv2("ICBR.csv")
dados_cambio <- read_csv2("INPC(Câmbio).csv")
dados_selic <- read_csv2("TxJuros.csv")

# Renomear colunas e garantir que 'Data' seja do tipo Data
dados_pim <- dados_pim %>% mutate(Data = dmy(Data))
dados_icbr <- dados_icbr %>% rename(ICBR = IC_Br) %>% mutate(Data = dmy(Data))
dados_cambio <- dados_cambio %>% rename(CAMBIO_REAL = INPC_TxCambioEfetivaReal) %>% mutate(Data = dmy(Data))
dados_selic <- dados_selic %>% rename(SELIC = Selic_Acum) %>% mutate(Data = dmy(Data))


# 2. CONSTRUÇÃO DA BASE DE DADOS E ENGENHARIA DE VARIÁVEIS
# ------------------------------------------------------------------------------

# Juntar todas as tabelas em uma única base de dados
base_final <- dados_pim %>%
  full_join(dados_icbr, by = "Data") %>%
  full_join(dados_cambio, by = "Data") %>%
  full_join(dados_selic, by = "Data") %>%
  arrange(Data) %>%
  drop_na()

# Criar as variáveis transformadas (logaritmos, dummies e interações)
base_modelos <- base_final %>%
  mutate(
    lnPIM = log(PIM),
    lnICBR = log(ICBR),
    lnCAMBIO_REAL = log(CAMBIO_REAL),
    
    D_Boom_2000s = ifelse(Data >= ymd("2003-01-01") & Data <= ymd("2011-01-01"), 1, 0),
    D_Boom_Pandemia = ifelse(Data >= ymd("2021-01-01"), 1, 0),
    
    Interacao_ICBR_2000s = lnICBR * D_Boom_2000s,
    Interacao_ICBR_Pandemia = lnICBR * D_Boom_Pandemia,
    Interacao_CAMBIO_2000s = lnCAMBIO_REAL * D_Boom_2000s,
    Interacao_CAMBIO_Pandemia = lnCAMBIO_REAL * D_Boom_Pandemia
  )

# Verificação rápida da base final
summary(base_modelos)


# 3. CONVERSÃO PARA OBJETO DE SÉRIE TEMPORAL
# ------------------------------------------------------------------------------

start_year <- year(first(base_modelos$Data))
start_month <- month(first(base_modelos$Data))

# Criar o objeto 'ts' removendo a coluna 'Data'
dados_ts <- ts(select(base_modelos, -Data),
               start = c(start_year, start_month),
               frequency = 12)


# 4. TESTES DE RAIZ UNITÁRIA (ADF)
# ------------------------------------------------------------------------------
# O objetivo é confirmar que as variáveis são I(0) ou I(1).

# Testes em Nível (espera-se não serem estacionárias)
summary(ur.df(dados_ts[, "lnPIM"], type = "trend", selectlags = "AIC"))
summary(ur.df(dados_ts[, "lnICBR"], type = "trend", selectlags = "AIC"))
summary(ur.df(dados_ts[, "lnCAMBIO_REAL"], type = "trend", selectlags = "AIC"))
summary(ur.df(dados_ts[, "SELIC"], type = "trend", selectlags = "AIC"))

# Testes em Primeira Diferença (espera-se serem estacionárias)
summary(ur.df(diff(dados_ts[, "lnPIM"]), type = "drift", selectlags = "AIC"))
summary(ur.df(diff(dados_ts[, "lnICBR"]), type = "drift", selectlags = "AIC"))
summary(ur.df(diff(dados_ts[, "lnCAMBIO_REAL"]), type = "drift", selectlags = "AIC"))
summary(ur.df(diff(dados_ts[, "SELIC"]), type = "drift", selectlags = "AIC"))



# 5. ANÁLISE DO MODELO 1 (CANAL DO CÂMBIO)
# ------------------------------------------------------------------------------

# Definir a fórmula completa do Modelo 1
formula_cambio <- lnCAMBIO_REAL ~ lnICBR + SELIC + D_Boom_2000s + D_Boom_Pandemia + Interacao_ICBR_2000s + Interacao_ICBR_Pandemia

# Encontrar a ordem ótima de defasagens
auto_cambio <- auto_ardl(formula_cambio, data = dados_ts, max_order = 5)
ordem_cambio <- auto_cambio$best_order

# Estimar o modelo ARDL final
modelo_final_cambio <- ardl(formula_cambio, data = dados_ts, order = ordem_cambio)

# Análise dos resultados do Modelo 1
print("Coeficientes de Longo Prazo:")
print(multipliers(modelo_final_cambio))
print("Teste de Limites para Cointegração:")
print(bounds_f_test(modelo_final_cambio, case = 3))


# 6. ANÁLISE DO MODELO 2 (CANAL DA DESINDUSTRIALIZAÇÃO)
# ------------------------------------------------------------------------------

# Definir a fórmula completa do Modelo 2
formula_pim <- lnPIM ~ lnCAMBIO_REAL + SELIC + D_Boom_2000s + D_Boom_Pandemia + Interacao_CAMBIO_2000s + Interacao_CAMBIO_Pandemia

# Encontrar a ordem ótima de defasagens
auto_pim <- auto_ardl(formula_pim, data = dados_ts, max_order = 5)
ordem_pim <- auto_pim$best_order

# Estimar o modelo ARDL final
modelo_final_pim <- ardl(formula_pim, data = dados_ts, order = ordem_pim)

# Análise dos resultados do Modelo 2
print("Coeficientes de Longo Prazo:")
print(multipliers(modelo_final_pim))
print("Teste de Limites para Cointegração:")
print(bounds_f_test(modelo_final_pim, case = 3))


# 7. DIAGNÓSTICO E ROBUSTEZ DO MODELO 2
# ------------------------------------------------------------------------------
# Focamos no Modelo 2, pois foi o único que apresentou cointegração.

print("--- DIAGNÓSTICOS DO MODELO 2 ---")
# Teste de Autocorrelação Serial (Breusch-Godfrey) - H0: Não há autocorrelação
print(bgtest(modelo_final_pim))

# Teste de Heterocedasticidade (Breusch-Pagan) - H0: Não há heterocasticidade
print(bptest(modelo_final_pim))

# Análise de Robustez para a Heterocedasticidade
print(">>>> ANÁLISE DE ROBUSTEZ (ERROS-PADRÃO ROBUSTOS) <<<<")
# Recalcula os p-valores dos coeficientes de curto prazo
print(coeftest(modelo_final_pim, vcov = vcovHC(modelo_final_pim, type = "HC3")))

# --- ECM (termo de correção de erro) do Modelo 2 ---
cat("\n>>>> ECM do MODELO 2 <<<<\n")

# Função compatível com diferentes versões do pacote ARDL
get_ecm <- function(m){
  if ("ARDL" %in% .packages(all.available = TRUE)) {
    exps <- getNamespaceExports("ARDL")
    if ("ecm"  %in% exps) return(ARDL::ecm(m))    # versões mais novas
    if ("uecm" %in% exps) return(ARDL::uecm(m))   # versões antigas
  }
  stop("Sua versão do pacote ARDL não possui 'ecm' nem 'uecm'. Atualize o pacote ARDL.")
}

ecm_obj <- get_ecm(modelo_final_pim)

# Algumas versões retornam um objeto 'lm' diretamente; outras, um wrapper com $lm
ecm_fit <- if (inherits(ecm_obj, "lm")) ecm_obj else if (!is.null(ecm_obj$lm)) ecm_obj$lm else ecm_obj

print(summary(ecm_fit))  # coeficiente do ECT (speed of adjustment) deve ser < 0 e significativo

# Erros-padrão robustos no ECM (HC3)
cat("\n--- ECM com erros robustos (HC3) ---\n")
print(coeftest(ecm_fit, vcov = vcovHC(ecm_fit, type = "HC3")))

# --- Autocorrelação sazonal até 12 defasagens (mensal) ---
cat("\n--- Breusch-Godfrey (ordem 12) ---\n")
print(bgtest(modelo_final_pim, order = 12))

# --- Wald: quebras paramétricas entre regimes (long-run via interações) ---
cat("\n--- TESTES WALD DE QUEBRA ENTRE REGIMES ---\n")
# H0: Interacao_CAMBIO_2000s = 0  (efeito não difere do período base)
print(linearHypothesis(modelo_final_pim, "Interacao_CAMBIO_2000s = 0"))

# H0: Interacao_CAMBIO_Pandemia = 0  (efeito não difere do período base)
print(linearHypothesis(modelo_final_pim, "Interacao_CAMBIO_Pandemia = 0"))

# H0: efeitos iguais entre 2000s e pós-pandemia
print(linearHypothesis(modelo_final_pim,
                       "Interacao_CAMBIO_2000s = Interacao_CAMBIO_Pandemia"))

# --- Efeitos de longo prazo por regime (para reportar no texto) ---
lr_tab <- multipliers(modelo_final_pim) %>% as.data.frame() %>% tibble::rownames_to_column("term")
beta_base <- lr_tab %>% dplyr::filter(term == "lnCAMBIO_REAL") %>% dplyr::pull(Estimate)
beta_2000 <- beta_base + (lr_tab %>% dplyr::filter(term == "Interacao_CAMBIO_2000s") %>% dplyr::pull(Estimate))
beta_pand <- beta_base + (lr_tab %>% dplyr::filter(term == "Interacao_CAMBIO_Pandemia") %>% dplyr::pull(Estimate))

cat("\nLong run do câmbio por regime:\n")
cat(
  sprintf("• %-18s: % .4f",
          c("Base (sem dummy)", "Boom 2000s", "Pós-pandemia"),
          c(beta_base, beta_2000, beta_pand)),
  sep = "\n"
)

car::linearHypothesis(modelo_final_pim,
                      c("Interacao_CAMBIO_2000s = 0", "Interacao_CAMBIO_Pandemia = 0"))
car::linearHypothesis(modelo_final_pim,
                      c("D_Boom_2000s = 0", "D_Boom_Pandemia = 0"))



# 8. VISUALIZAÇÃO DOS RESULTADOS
# ------------------------------------------------------------------------------

# --- GRÁFICO 1: Série Temporal das Variáveis ---
booms <- tibble(
  inicio = as.Date(c("2003-01-01", "2021-01-01")),
  fim = as.Date(c("2011-12-31", "2025-07-01"))
)
dados_para_plot_series <- base_modelos %>%
  select(Data, lnPIM, lnICBR, lnCAMBIO_REAL, SELIC) %>%
  pivot_longer(cols = -Data, names_to = "variavel", values_to = "valor") %>%
  mutate(
    variavel_renamed = case_when(
      variavel == "lnCAMBIO_REAL" ~ "Câmbio Real (Log)",
      variavel == "lnICBR"        ~ "Índice de Commodities (Log)",
      variavel == "lnPIM"         ~ "Produção da Ind. de Transformação (Log)",
      variavel == "SELIC"         ~ "Taxa de Juros (Selic)"
    )
  )
grafico_series <- ggplot(dados_para_plot_series, aes(x = Data, y = valor)) +
  geom_rect(data = booms, aes(xmin = inicio, xmax = fim, ymin = -Inf, ymax = Inf), inherit.aes = FALSE, fill = "grey90", alpha = 0.5) +
  geom_line(color = "navy") +
  facet_wrap(~ variavel_renamed, scales = "free_y", ncol = 1) +
  labs(title = "Evolução das Variáveis de Análise (2002-2025)", x = "Ano", y = "Valor") +
  theme_minimal() +
  theme(plot.title = element_text(size = 11, hjust = 0.5))
print(grafico_series)

# --- GRÁFICO 2: Long run multipliers (Modelo 2) com IC 95% ---

# 1) Captura robusta da tabela de long-run multipliers
lr_raw <- multipliers(modelo_final_pim)

if ("Term" %in% colnames(lr_raw)) {
  # Caso como no seu print: já vem com coluna 'Term'
  lr_df <- tibble::as_tibble(lr_raw) %>%
    dplyr::rename(termo = Term,
                  Estimate = Estimate,
                  `Std. Error` = `Std. Error`)
} else {
  # Caso clássico: nomes estão nos rownames
  lr_df <- as.data.frame(lr_raw) %>%
    tibble::rownames_to_column("termo")
}

# 2) Limpeza + nomes bonitos
lr_plot <- lr_df %>%
  dplyr::filter(termo != "(Intercept)") %>%
  dplyr::mutate(
    ci_low  = Estimate - 1.96 * `Std. Error`,
    ci_high = Estimate + 1.96 * `Std. Error`,
    termo_renamed = dplyr::case_when(
      termo == "lnCAMBIO_REAL"             ~ "Câmbio Real (log)",
      termo == "SELIC"                     ~ "Taxa Selic",
      termo == "D_Boom_2000s"              ~ "Dummy: Boom 2000s",
      termo == "D_Boom_Pandemia"           ~ "Dummy: Pós-pandemia",
      termo == "Interacao_CAMBIO_2000s"    ~ "Câmbio × Boom 2000s",
      termo == "Interacao_CAMBIO_Pandemia" ~ "Câmbio × Pós-pandemia",
      TRUE ~ termo
    )
  )

# 3) Garantir fator (ordem do maior pro menor) e plotar
lr_plot$termo_renamed <- forcats::fct_rev(forcats::fct_reorder(lr_plot$termo_renamed, lr_plot$Estimate))

grafico_lr <- ggplot(lr_plot, aes(x = Estimate, y = termo_renamed)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_point(size = 2) +
  geom_errorbarh(aes(xmin = ci_low, xmax = ci_high), height = 0.15) +
  labs(title = "Efeitos de Longo Prazo – Modelo 2",
       x = "Coeficiente (IC 95%)", y = NULL) +
  scale_y_discrete(drop = FALSE) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

print(grafico_lr)


# -------------------------ISSO É TUDO PESSOAL!!---------------------------------------
