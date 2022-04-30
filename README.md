# Jack Schreuder Project Proposal

## Domain of Interest

#### Background

I propose a project based around studying the ecology and visitation of the US national parks, specifically broken down based on state. Which states have the most land allocated for national park conservation, and which of these states receive the most visitors. Is there a relationship here, and if there is, what can it tell us about the modern practice of enclosing the commons and/or the creation of a mythic frontier to solve a crisis of masculinity.
- Why am I interested in this subject?
  - Whether or not National Parks are a part of some sort of odd quest to recreate "frontier living" and harden so called "soft" modern men, they are some of the last remaining untouched pieces of wilderness in the United States, and in the whole world. Therefore, it is important to understand if National Parks are in fact meaningfully intact tracts of well preserved land.
  - Which states (maybe which parks too) have the most visitors, and what do those places tell us about who might be visiting?
- What other examples of data driven project have I found that relate to this subject?
  - [This article](https://www.williamcronon.net/writing/Trouble_with_Wilderness_Main.html) by William Cronen explores the idea that mainstream environmentalism may have confused the general population in terms of whether National Parks are some of the last places that (as Cronen puts it) civilization, the human disease, has not fully infected. Cronen cites a lot of Transcendentalist writing and historical data to determine whether National Parks were created to conserve nature, or as a way for "soft men" to get back in touch with a supposedly more masculine version of themselves, ie some character in line with the Teddy Roosevelt rough-rider archetype.
  - [A second article](https://www.outsideonline.com/culture/books-media/leave-it-as-it-is-david-gessner-book-excerpt/) talks about the idea that National Parks were created as "empty places", but what this really means is places untouched by European settlers. When the first national parks where made, the word wilderness was synonymous with "place Indians were". Gessner (the author) points out that the idea of National Parks as "untouched" lands is particularly cruel to the indigenous people that used to live as stewards of that land.
  - [A list website](https://www.nationalparks.org/connect/blog/size-largest-national-parks-will-blow-your-mind) provides a few of the largest area national parks, and a description about each of them. This could be found out from the data alone, but this article adds more context to the situation, which could prove helpful when interpreting the analysis.
- Data driven questions I hope to answer
  - Breakdown of States by total national park area, and number of national parks. Breakdown also by region (eg "Southwest", "Intermountain", etc...)
  - How many people visit the parks? By total across state? By individual park? By month of the year?
  - Is there a correlation between the size of a park and the number of people that have visited it?

## Finding Data

- [Park Acreage Data](https://www.kaggle.com/datasets/nationalparkservice/park-biodiversity)
  - This is a kaggle dataset, it has two CSVs one that has park acreage and one that lists the presence or absence of important species in the park. It was compiled from NPS public data reports. 6 columns, 56 rows. Can answer questions related to acreage per state, can be joined iwht other sets to come up with ratio of park area/state area, and also park area by region.
- [Park Visitation Data](https://www.kaggle.com/datasets/karthickveerakumar/national-park)
  - This is also a kaggle data set it contains the log number of visitors for each national park between 2010 and 2016. Kaggle does not list how it was collected, although it was presumably compiled from public NPS reports like the first dataset. 12 columns, 25.6K rows. Can show the number of people who visit in a given year, or over a 6 year stretch, can combine to show by state, region, or park. Can also be broken down by month.
- [State Area and Population Data](http://goodcsv.com/geography/us-states-territories/)
  - This is from good CSV and includes the 2019 population for each state, as well as the area of each state, compiled from wikepedia. 7 columns, 53 rows. This set will be mainly used to assign state names and abbreviations, but also contains a simple column for population, and land area, which will be used for computed metrics.
