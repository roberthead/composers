# Prime Movers

'Prime Movers' (2016) is a data visualization of western classical composers extracted from online data.

The intention of the project is to offer a timeline of significant composers selected by algorithm from source data rather than by subjective opinion. Essentially, the assessment of each composer, which is used both for the selection process and for display elements, has been culturally crowd-sourced.

The source material has been extracted and scraped from raw, publicly available online data. Composers were programmatically imported from several lists of composers on wikipedia. The relative 'significance' of each composer was then evaluated by several factors:
- The length of their individual wikipedia page
- The number of google search results
- The number of sources that list the composer
- Designations of royalty, which count against

The collated data is served by a Ruby on Rails application backed by a postgresql database. The data visualization is written in javascript using the d3js library.

The visualization is publicly available at http://composers-api.herokuapp.com
The json feed is available at http://composers-api.herokuapp.com/composers.json
The code is open source and available at https://github.com/roberthead/composers
