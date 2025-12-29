/*==============================================================================
    MOVIES DATA CLEANING
    Dataset: movies.csv (IMDB movies dataset)
==============================================================================*/

clear all
set more off

* Set working directory - change this to your path
* cd "/path/to/your/folder"

/*------------------------------------------------------------------------------
    IMPORT DATA
------------------------------------------------------------------------------*/
import delimited "movies.csv", varnames(1) stringcols(_all) clear

/*------------------------------------------------------------------------------
    CLEAN YEAR VARIABLE
------------------------------------------------------------------------------*/
* Remove parentheses and extract just the start year
gen year_clean = regexs(1) if regexm(year, "\(([0-9]{4})")
destring year_clean, replace
drop year
rename year_clean year
label var year "Release Year"

/*------------------------------------------------------------------------------
    CLEAN RATING VARIABLE
------------------------------------------------------------------------------*/
* Convert to numeric (missing values will become .)
destring rating, gen(rating_num) force
drop rating
rename rating_num rating
label var rating "IMDB Rating"

/*------------------------------------------------------------------------------
    CLEAN GENRE VARIABLE
------------------------------------------------------------------------------*/
* Remove extra whitespace and newlines
replace genre = strtrim(genre)
replace genre = subinstr(genre, char(10), "", .)
replace genre = subinstr(genre, char(13), "", .)
replace genre = stritrim(genre)
label var genre "Genre(s)"

/*------------------------------------------------------------------------------
    CLEAN VOTES VARIABLE
------------------------------------------------------------------------------*/
* Remove commas and convert to numeric
replace votes = subinstr(votes, ",", "", .)
replace votes = strtrim(votes)
destring votes, gen(votes_num) force
drop votes
rename votes_num votes
label var votes "Number of Votes"

/*------------------------------------------------------------------------------
    CLEAN RUNTIME VARIABLE
------------------------------------------------------------------------------*/
* Convert to numeric
destring runtime, gen(runtime_num) force
drop runtime
rename runtime_num runtime
label var runtime "Runtime (minutes)"

/*------------------------------------------------------------------------------
    CLEAN GROSS VARIABLE
------------------------------------------------------------------------------*/
* Remove any non-numeric characters and convert
replace gross = strtrim(gross)
destring gross, gen(gross_num) force
drop gross
rename gross_num gross
label var gross "Gross Revenue"

/*------------------------------------------------------------------------------
    CLEAN MOVIE TITLE
------------------------------------------------------------------------------*/
replace movies = strtrim(movies)
replace movies = subinstr(movies, char(10), "", .)
replace movies = subinstr(movies, char(13), "", .)
rename movies title
label var title "Movie Title"

/*------------------------------------------------------------------------------
    CLEAN ONE-LINE DESCRIPTION
------------------------------------------------------------------------------*/
rename oneline description
replace description = strtrim(description)
replace description = subinstr(description, char(10), " ", .)
replace description = subinstr(description, char(13), "", .)
replace description = stritrim(description)
label var description "Plot Summary"

/*------------------------------------------------------------------------------
    CLEAN STARS VARIABLE
------------------------------------------------------------------------------*/
* Remove "Director:" and "Stars:" labels and clean up
replace stars = subinstr(stars, "Director:", "", .)
replace stars = subinstr(stars, "Stars:", "", .)
replace stars = subinstr(stars, "|", "", .)
replace stars = subinstr(stars, char(10), " ", .)
replace stars = subinstr(stars, char(13), "", .)
replace stars = stritrim(stars)
replace stars = strtrim(stars)
label var stars "Director and Cast"

/*------------------------------------------------------------------------------
    REORDER VARIABLES
------------------------------------------------------------------------------*/
order title year genre rating description stars votes runtime gross

/*------------------------------------------------------------------------------
    SUMMARY STATISTICS
------------------------------------------------------------------------------*/
describe
summarize rating votes runtime gross

/*------------------------------------------------------------------------------
    SAVE CLEANED DATA
------------------------------------------------------------------------------*/
save "movies_clean.dta", replace
export delimited "movies_clean.csv", replace

display _n "Data cleaning complete!"
display "Saved: movies_clean.dta and movies_clean.csv"
