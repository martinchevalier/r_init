rm(list = ls(all.names = TRUE))

.download <- FALSE
if(!exists(".initOK")) source("site/init.R", encoding = "utf8")

####
# SITE ----
####

rmarkdown::render("site/index.Rmd", encoding = "utf8")
file.copy("site/index.html", "#output/index.html", overwrite = TRUE)

rmarkdown::render("site/module1.Rmd", encoding = "utf8")
file.copy("site/module1.html", "#output/module1.html", overwrite = TRUE)

rmarkdown::render("site/module2.Rmd", encoding = "utf8")
file.copy("site/module2.html", "#output/module2.html", overwrite = TRUE)

rmarkdown::render("site/module3.Rmd", encoding = "utf8")
file.copy("site/module3.html", "#output/module3.html", overwrite = TRUE)

####
# LIVRET ----
####

compilerLivret <- function(.sol = FALSE, .wd = "livret"){
  .old_wd <- getwd()
  setwd(.wd)
  rmarkdown::render("livret.Rmd", encoding = "utf8")
  system("pdflatex livret.tex")
  system("makeindex livret.idx ")
  system("pdflatex livret.tex")
  setwd(.old_wd)
}

# Version sans corrections
compilerLivret(.sol = FALSE)
file.copy("livret/livret.pdf", "#output/livret.pdf", overwrite = TRUE)

# Version avec corrections
compilerLivret(.sol = TRUE)
file.copy("livret/livret.pdf", "#output/livret_sol.pdf", overwrite = TRUE)

####
# PRESENTATION ----
####

# Version beamer
rmarkdown::render("presentation/presentation.Rmd", encoding = "utf8", clean = FALSE)
file.copy("presentation/presentation.pdf", "#output/presentation_beamer.pdf", overwrite = TRUE)

# Ajout de la ligne "handout: yes" dans le fichier Markdown
md <- readLines("presentation/presentation.utf8.md")
md <- c(md[1], "handout: yes", md[2:length(md)])
writeLines(md, "presentation/presentation.utf8.md")

# Version handout
rmarkdown::render("presentation/presentation.utf8.md", encoding = "utf8", output_file = "presentation.pdf")
file.copy("presentation/presentation.pdf", "#output/presentation.pdf", overwrite = TRUE)

# Suppression des fichiers intermediaires
file.remove("presentation/presentation.knit.md", "presentation/presentation.utf8.md")