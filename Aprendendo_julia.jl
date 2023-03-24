using DataFrames
using LinearAlgebra
using Gadfly 
using TableView
using CSV
using ExcelReaders
using XLSX

# Start Importing Fundos data set 

fundos = XLSX.readxlsx("C:/Users/mathe/OneDrive/Documentos/Finanças/fundos.xlsx")

dt = DataFrames.DataFrame(fundos["Sheet1"][:])

column_names = Array{String}(dt[1, :])

for i in eachindex(column_names)
    column_names[i] = replace(column_names[i], "\n" => " ")
    column_names[i] = replace(column_names[i], " " => "_")
end

# Rename the data frame 
rename!(dt, column_names, makeunique=true)

# Checking 

names(dt)

dt[:, [:Nome, :Classe, :Classificação_Anbima]]

dropmissing(dt[!, [:Nome, :Classe, :Classificação_Anbima, :Gestora_]])


