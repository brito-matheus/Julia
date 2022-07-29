using DataFrames
using LinearAlgebra
using Gadfly 
using XLSX 


# Start Importing Fundos data set 

fundos = XLSX.readxlsx("C:/Users/mathe/OneDrive/Documentos/Finanças/fundos.xlsx")

fundos = DataFrame(fundos)