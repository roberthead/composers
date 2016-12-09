let url = 'http://composers-api.herokuapp.com/composers.json';
let earliestBirthYear, latestBirthYear, yearsTotal;

let eraColor = {
  renaissance: "#339933",
  baroque: "#999933",
  classical: "#993333",
  romantic: "#993399",
  modernist: "#333399"
}

//This function contains the logic for rendering our image from a dataset
let updateGraph = function(dataset) {
	//select a specific set of objects inside of the dataset
  let svgContainer = d3.select('svg')
	let timelines = svgContainer.selectAll('line').data(dataset);
	let texts = svgContainer.selectAll('text').data(dataset);

  let currentY = 0
	let age, ellapsedPortion = 0
	let red, green, blue = 0
  let lifespan

  timelines.enter().append('line')
		.attr('x1', function(composer) {
      return (composer.birth_year - earliestBirthYear) * 2 + 25
		})
		.attr('y1', function (composer, index) {
      return (index * 25) % 800 + 47
		})
		.attr('x2', function(composer) {
			lifespan = composer.death_year - composer.birth_year;
      return (composer.birth_year - earliestBirthYear) * 2 + 25 + lifespan * 2
		})
    .attr('y2', function(composer, index) {
      return (index * 25) % 800 + 47
    })
		.attr('stroke', function (composer) {
      return eraColor[composer.primary_era.toLowerCase()]
		})
		.attr('stroke-width', function (composer) {
			return 2;
		})
		.style('opacity', 1)

    texts.enter().append('text')
      .attr('x', function(composer) {
        return (composer.birth_year - earliestBirthYear) * 2 + 25
      })
      .attr('y', function(composer, index) {
        return (index * 25) % 800 + 45
      })
      .text(function(composer) { return composer.name })
      .attr("font-family", "Open Sans, sans-serif")
      .attr("font-size", function (composer) {
        return Math.pow(composer.google_results_count + composer.wikipedia_page_length, 0.23)
      })
}

// this function contains the logic for changing the data
var parseData = function(dataset) {
	//use any logic to parse/update your data here
	composers = dataset.composers;
	earliestBirthYear = dataset.earliest_birth_year;
	latestBirthYear = dataset.latest_birth_year;
	yearsTotal = latestBirthYear - earliestBirthYear;

	//now render the visual
	updateGraph(composers);
}

d3.json(url, parseData);
