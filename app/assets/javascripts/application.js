// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require d3
//= require_tree .

let url = 'http://composers-api.herokuapp.com/composers.json'
let earliestBirthYear, latestDeathYear, yearsTotal, pixelsPerYear
let stageWidth = 1600
let stageHeight = 900
let eraColor = {
  medieval: "#55BB55",
  renaissance: "#55BBBB",
  baroque: "#BBBB55",
  classical: "#BB5555",
  romantic: "#BB55BB",
  modernist: "#5555BB"
}

function updateGraph(dataset) {
  //select a specific set of objects inside of the dataset
  let svgContainer = d3.select('svg')

  let lifelines = svgContainer.selectAll('line.lifeline').data(dataset)
  let texts = svgContainer.selectAll('text').data(dataset)

  let currentY = 0
  let age, ellapsedPortion = 0
  let red, green, blue = 0
  let lifespan

  lifelines.enter().append('line')
    .attr('x1', function(composer) {
      return xForYear(composer.birth_year)
    })
    .attr('y1', function (composer, index) {
      return yForIndex(index)
    })
    .attr('x2', function(composer) {
      return xForYear(composer.death_year)
    })
    .attr('y2', function(composer, index) {
      return yForIndex(index)
    })
    .attr('stroke', function (composer) {
      return eraColor[composer.primary_era.toLowerCase()]
    })
    .attr('stroke-width', function (composer) {
      return 2
    })
    .attr('class', 'lifeline')
    .style('opacity', 1)

  texts.enter().append('text')
    .attr('x', function(composer) {
      return xForYear(composer.birth_year)
    })
    .attr('y', function(composer, index) {
      return yForIndex(index) - 3
    })
    .text(function(composer) { return composer.name })
    .attr("font-family", "Open Sans, sans-serif")
    .attr("font-size", function (composer) {
      return Math.pow(composer.google_results_count + composer.wikipedia_page_length, 0.23)
    })
}

function parseData(dataset) {
  composers = dataset.composers
  earliestBirthYear = dataset.earliest_birth_year
  latestDeathYear = dataset.latest_death_year
  yearsTotal = latestDeathYear - earliestBirthYear
  pixelsPerYear = stageWidth / yearsTotal

  renderTimeline(25)
  renderTimeline(stageHeight - 25)
  updateGraph(composers)
}

function renderTimeline(offset) {
  let svgContainer = d3.select('svg')

  svgContainer.append('line')
    .attr('x1', 25)
    .attr('y1', offset)
    .attr('x2', 1575)
    .attr('y2', offset)
    .attr('stroke', '#555555')
    .attr('stroke-width', 1.5)
    .attr('class', 'timeline')

  let elementClass = "century-mark-" + offset
  let centuryMarks = svgContainer.selectAll("line." + elementClass).data(
    [1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000]
  )

  centuryMarks.enter().append('line')
    .attr('x1', function (year) { return xForYear(year) })
    .attr('y1', offset - 5)
    .attr('x2', function (year) { return xForYear(year) })
    .attr('y2', offset + 5)
    .attr('stroke', '#555555')
    .attr('stroke-width', 1)
    .attr('class', elementClass)
}

function xForYear(year) {
  return (year - earliestBirthYear) * pixelsPerYear
}

function yForIndex(index) {
  let topMargin = 75
  let bottomMargin = 25
  let height = stageHeight - topMargin - bottomMargin
  let lineHeight = 25
  return topMargin + (index * lineHeight) % height
}

d3.json(url, parseData)
