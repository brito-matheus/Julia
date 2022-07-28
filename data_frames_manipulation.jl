#### Packages that will be used
using CSV, Statistics, DataFrames
using RData, RDatasets, Gadfly, LinearAlgebra
using TableView

using XLSX


fundos = XLSX.readxlsx("C:/Users/mathe/OneDrive/Documentos/Finanças/fundos.xlsx")

XLSX.sheetnames(fundos)

# Example Data Set

DataFrame(fundos)

rdataset = RDatasets.datasets()

Movies = dataset("ggplot2", "movies")

# Names
names(Movies)

# Size
size(Movies)

# Summary function

function spread(x)
        return(maximum(skipmissing(x)) - minimum(skipmissing(x)))
end

function SSE(x)
        return(mean((x - mean(x)).^2))
end

showtable(
describe(Movies,
cols = ["Year", "Budget", "Length"], :min, :max, :mean, :nunique, :spread => spread)
)


# Selecting some columns
Movies2 = select(Movies,
        ["Title", "Year", "Rating", "Budget", "Action", "Animation",
        "Comedy", "Documentary", "Romance", "Short"])


# Selecing Movies with Rating above 9, sort by year
showtable(
        sort(
        dropmissing(Movies2[Movies2.Rating .>= 9 , :]) , :Year, rev = true
            )
        )


# Summary of the movies with rating above the 5
describe(Movies2[Movies2[:Rating] .> 5, :])

# The Exclamation point ! in a function means that the input will be modified

head(sort(Movies2, ["Year", "Rating", "Budget", "Title"], rev = true))

describe(
filter([:Year, :Rating] => (Year, Rating) -> Year >= 2000 && Rating > 5, Movies2)
)

# One way to filter
# &&  is the conditional & and || is |
sort(
filter([:Year, :Rating] =>
        (x, y) -> x > 2000 && y > 5, Movies2), ["Year", "Rating"], rev = true)

# Skipping Missing in Budget
describe(
subset(Movies2, :rating => rating -> rating . >= 9, skipmissing = true)
)

# Useful function to select columns Not, Between, Cols and All s
describe(
Movies2[:, Between(2,3)]
)

# Filtering based on rows value

# Note that the point (.) before the logical operations are necessary,
# And the parenthisis delimitating the logical conditions
describe(
Movies2[(Movies2.Year .>= 2000) .& (5 .<= Movies2.Rating .<= 8), :]
)

# Print the results in the terminal
@show(
sort(
Movies2[(Movies2.Year .<= 2000) .&
        (Movies2.Rating .>= 9)
, :], ["Rating", "Year"], rev = true)
)

# Filtering rows based on in condition
Movies2[in.(Movies2.Year, Ref([1980,1990,2000])) .&
        in.(Movies2.Rating, Ref([0,5,10])),
        :]


# Selection using using Not, Cols, All and regex

describe(select(Movies2, [:Action, :Rating, :Documentary]))

# Selection by regex
describe(select(Movies2, r"Rating", r"Doc"))

describe(select(Movies2, Not(["Rating", "Documentary"])))

describe(select(Movies2, Not([:Rating, :Documentary])))


df = DataFrame(x1=[1, 2], x2=[3, 4], y=[5, 6])

# Transform columns by row

function div_1000(x) return(x/1000) end

describe(select(Movies2, :Budget, :Budget => ByRow(div_1000)))

# Making transformations in all columns

DF = DataFrame(A  = repeat([missing, missing, 1,0], 250),
               B = repeat([4, missing, 1, 0], 250),
               C = repeat([missing, 10, 1, 0], 250),
               D = repeat([1, 2,3,4], 250))

replace(DF.A, missing => "Matheus")


# Transforma columns
showtable(
        transform(DF, AsTable([:C, :D]) .=> ByRow.(
        [sum∘skipmissing,
        x -> count(ismissing, x),
        maximum∘skipmissing,
        minimum∘skipmissing]
        ) .=> [:Sum, :N, :Maximum, :Minimum])
)


Pkg.add("DataFramesMeta")
Pkg.add("Query")

using Query
