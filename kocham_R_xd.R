# Załadowanie potrzebnych bibliotek
library(Information)
library(scorecard)
library(dplyr)

# Wybór zmiennych do analizy IV (wykluczenie zmiennych pomocniczych)
exclude_cols <- c("LP", "data_akceptacji", "kwota_kredytu", "oproc_refin", 
                  "oproc_konkur", "koszt_pieniadza", "oproc_propon", 
                  "umowa_N", "koszt_propon", "koszt_konkur")

# Wybieramy wszystkie zmienne poza wykluczonymi
vars_to_analyze <- setdiff(names(project_data), c(exclude_cols, "akceptacja_klienta"))

# Przygotowanie danych do analizy
iv_data <- project_data[, c(vars_to_analyze, "akceptacja_klienta")]

# Upewnienie się, że zmienna celu jest typu numeric
iv_data$akceptacja_klienta <- as.numeric(as.character(iv_data$akceptacja_klienta))

# Obliczenie IV dla wszystkich zmiennych z domyślnymi ustawieniami binowania
iv_results <- Information::create_infotables(data = iv_data, 
                                             y = "akceptacja_klienta",
                                             parallel = FALSE)

# Wyodrębnienie wyników IV
iv_values <- iv_results$Summary

# Sortowanie wartości IV w kolejności malejącej
iv_values <- iv_values[order(-iv_values$IV), ]

# Wyświetlenie wyników
cat("\n=== Wartości IV dla zmiennych (posortowane) ===\n")
for (i in 1:nrow(iv_values)) {
  cat(sprintf("%s: %.4f\n", iv_values$Variable[i], iv_values$IV[i]))
}
