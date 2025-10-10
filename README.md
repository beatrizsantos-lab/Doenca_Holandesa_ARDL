# Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa

**Autora**: Beatriz Santos 

---

## 📄 Resumo do Projeto

Este repositório contém os dados e o script R utilizados no artigo "Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa".

O estudo investiga empiricamente a manifestação da **Doença Holandesa** no Brasil, com foco no ciclo de alta das commodities pós-pandemia. Utilizando um modelo de Defasagens Distribuídas Autorregressivas (ARDL) com dados mensais de **janeiro de 2002 a julho de 2025**, o trabalho testa duas hipóteses centrais:
1.  Se o boom de commodities pós-pandemia teve efeitos negativos sobre a indústria de transformação brasileira através de uma persistente valorização cambial.
2.  Se a relação de longo prazo entre a taxa de câmbio e a produção industrial sofreu uma quebra estrutural entre o ciclo dos anos 2000 e o ciclo pós-pandemia.

## 📊 Principais Conclusões

Os resultados econométricos **não corroboram a hipótese da Doença Holandesa** para o Brasil no período analisado[cite: 157, 168]. Pelo contrário, as evidências sugerem que:

* **Relação Negativa com o Câmbio**: Uma **valorização** da taxa de câmbio real (queda do índice) tem um impacto **positivo** e estatisticamente significativo sobre a produção industrial no longo prazo. O coeficiente estimado indica que uma desvalorização da moeda está associada a uma *redução* da produção industrial.
* **Canal dos Insumos Importados**: Este achado oferece forte suporte à hipótese do **canal dos insumos e bens de capital importados**, onde a indústria se beneficia da modernização viabilizada por importações mais baratas, em detrimento da competitividade-preço via desvalorização cambial.
* **Ausência de Quebra Estrutural**: Os testes não encontraram evidências de quebra estrutural na relação entre os ciclos de commodities, sugerindo que a sensibilidade da indústria ao câmbio permaneceu estável nas últimas duas décadas.
* **Velocidade de Ajuste**: O modelo confirmou uma relação de cointegração estável, onde cerca de **15,4%** de qualquer desequilíbrio de curto prazo é corrigido a cada mês, com o sistema convergindo para o equilíbrio de longo prazo.

## 📂 Estrutura do Repositório

```
.
├── dados/
│   ├── PIM.csv                     # Dados: Pesquisa Industrial Mensal
│   ├── ICBR.csv                    # Dados: Índice de Commodities Brasil (IC-Br)
│   ├── INPC(Câmbio).csv            # Dados: Taxa de Câmbio Efetiva Real (INPC)
│   └── TxJuros.csv                 # Dados: Taxa de Juros Selic
├── script_analise_ardl.R           # Script R completo para replicação da análise
└── README.md                       # Este arquivo
```

## ⚙️ Pré-requisitos e Configuração

Para executar a análise, você precisará do **R** (versão 4.5.1 ou superior) e de um ambiente de desenvolvimento como o **RStudio**.

### Pacotes R

O script utiliza os seguintes pacotes. Execute o comando abaixo no seu console R para instalá-los:

```r
install.packages(c(
  "tidyverse", "lubridate", "urca", "ARDL", "lmtest", 
  "sandwich", "tseries", "strucchange", "car", "forcats"
))
```

## 🚀 Como Replicar a Análise

1.  **Clone o Repositório**:
    ```bash
    git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
    cd seu-repositorio
    ```

2.  **Organize os Arquivos**: Certifique-se de que os quatro arquivos de dados (`.csv`) estejam na subpasta `dados/` ou no mesmo diretório que o script `script_analise_ardl.R`. O script atual presume que os dados estão no mesmo diretório.

3.  **Execute o Script**: Abra o arquivo `script_analise_ardl.R` no RStudio e execute o código do início ao fim. O script é sequencial e realizará as seguintes etapas:
    * Carregamento e limpeza dos dados.
    * Criação das variáveis (logaritmos, dummies, interações).
    * Realização dos testes de raiz unitária (ADF).
    * Estimação e diagnóstico dos dois modelos ARDL.
    * Geração dos gráficos de resultados (Série Temporal e Efeitos de Longo Prazo).

## 🗃️ Fontes dos Dados

Os dados utilizados são públicos e foram extraídos das seguintes fontes:
* **Instituto Brasileiro de Geografia e Estatística (SIDRA/IBGE)**
* **Sistema Gerador de Séries Temporais do Banco Central do Brasil (SGS/BCB)**

## ✍️ Como Citar este Trabalho

Se você utilizar este código ou os resultados em sua pesquisa, por favor, cite o artigo:

> Santos, B. F. S. (2025). *Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa*. Artigo de Econometria Aplicada, Programa de Pós-Graduação em Economia, Universidade Federal de Alagoas (UFAL).
# Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa

**Autora**: Beatriz Santos 

---

## 📄 Resumo do Projeto

Este repositório contém os dados e o script R utilizados no artigo "Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa".

O estudo investiga empiricamente a manifestação da **Doença Holandesa** no Brasil, com foco no ciclo de alta das commodities pós-pandemia. Utilizando um modelo de Defasagens Distribuídas Autorregressivas (ARDL) com dados mensais de **janeiro de 2002 a julho de 2025**, o trabalho testa duas hipóteses centrais:
1.  Se o boom de commodities pós-pandemia teve efeitos negativos sobre a indústria de transformação brasileira através de uma persistente valorização cambial.
2.  Se a relação de longo prazo entre a taxa de câmbio e a produção industrial sofreu uma quebra estrutural entre o ciclo dos anos 2000 e o ciclo pós-pandemia.

## 📊 Principais Conclusões

Os resultados econométricos **não corroboram a hipótese da Doença Holandesa** para o Brasil no período analisado[cite: 157, 168]. Pelo contrário, as evidências sugerem que:

* **Relação Negativa com o Câmbio**: Uma **valorização** da taxa de câmbio real (queda do índice) tem um impacto **positivo** e estatisticamente significativo sobre a produção industrial no longo prazo. O coeficiente estimado indica que uma desvalorização da moeda está associada a uma *redução* da produção industrial.
* **Canal dos Insumos Importados**: Este achado oferece forte suporte à hipótese do **canal dos insumos e bens de capital importados**, onde a indústria se beneficia da modernização viabilizada por importações mais baratas, em detrimento da competitividade-preço via desvalorização cambial.
* **Ausência de Quebra Estrutural**: Os testes não encontraram evidências de quebra estrutural na relação entre os ciclos de commodities, sugerindo que a sensibilidade da indústria ao câmbio permaneceu estável nas últimas duas décadas.
* **Velocidade de Ajuste**: O modelo confirmou uma relação de cointegração estável, onde cerca de **15,4%** de qualquer desequilíbrio de curto prazo é corrigido a cada mês, com o sistema convergindo para o equilíbrio de longo prazo.

## 📂 Estrutura do Repositório

```
.
├── dados/
│   ├── PIM.csv                     # Dados: Pesquisa Industrial Mensal
│   ├── ICBR.csv                    # Dados: Índice de Commodities Brasil (IC-Br)
│   ├── INPC(Câmbio).csv            # Dados: Taxa de Câmbio Efetiva Real (INPC)
│   └── TxJuros.csv                 # Dados: Taxa de Juros Selic
├── script_analise_ardl.R           # Script R completo para replicação da análise
└── README.md                       # Este arquivo
```

## ⚙️ Pré-requisitos e Configuração

Para executar a análise, você precisará do **R** (versão 4.5.1 ou superior) e de um ambiente de desenvolvimento como o **RStudio**.

### Pacotes R

O script utiliza os seguintes pacotes. Execute o comando abaixo no seu console R para instalá-los:

```r
install.packages(c(
  "tidyverse", "lubridate", "urca", "ARDL", "lmtest", 
  "sandwich", "tseries", "strucchange", "car", "forcats"
))
```

## 🚀 Como Replicar a Análise

1.  **Clone o Repositório**:
    ```bash
    git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
    cd seu-repositorio
    ```

2.  **Organize os Arquivos**: Certifique-se de que os quatro arquivos de dados (`.csv`) estejam na subpasta `dados/` ou no mesmo diretório que o script `script_analise_ardl.R`. O script atual presume que os dados estão no mesmo diretório.

3.  **Execute o Script**: Abra o arquivo `script_analise_ardl.R` no RStudio e execute o código do início ao fim. O script é sequencial e realizará as seguintes etapas:
    * Carregamento e limpeza dos dados.
    * Criação das variáveis (logaritmos, dummies, interações).
    * Realização dos testes de raiz unitária (ADF).
    * Estimação e diagnóstico dos dois modelos ARDL.
    * Geração dos gráficos de resultados (Série Temporal e Efeitos de Longo Prazo).

## 🗃️ Fontes dos Dados

Os dados utilizados são públicos e foram extraídos das seguintes fontes:
* **Instituto Brasileiro de Geografia e Estatística (SIDRA/IBGE)**
* **Sistema Gerador de Séries Temporais do Banco Central do Brasil (SGS/BCB)**

## ✍️ Como Citar este Trabalho (Sujeito a alterações)

Se você utilizar este código ou os resultados em sua pesquisa, por favor, cite o artigo:

> Santos, B. F. S. (2025). *Cointegração entre Taxa de Câmbio e Produção Industrial no Brasil: Testando a Hipótese da Doença Holandesa*. Artigo de Econometria Aplicada, Programa de Pós-Graduação em Economia, Universidade Federal de Alagoas (UFAL).
