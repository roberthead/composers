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
let earliestBirthYear, latestDeathYear, yearsTotal
let stageWidth = 3200
let stageHeight = 1200
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
  let texts = svgContainer.selectAll('text.composer-name').data(dataset)

  let currentY = 0
  let age, ellapsedPortion = 0
  let red, green, blue = 0
  let lifespan

  lifelines.enter().append('line')
    .attr('x1', function(composer) { return xForYear(composer.birth_year) })
    .attr('y1', function (composer, index) { return yForIndex(index) })
    .attr('x2', function(composer) { return xForYear(composer.death_year) })
    .attr('y2', function(composer, index) { return yForIndex(index) })
    .attr('stroke', function (composer) { return eraColor[composer.primary_era.toLowerCase()] })
    .attr('stroke-width', 1.5)
    .attr('class', 'lifeline')
    .style('opacity', 1)

  texts.enter().append('text')
    .attr('x', function(composer) { return xForYear(composer.birth_year) })
    .attr('y', function(composer, index) { return yForIndex(index) - 4 })
    .text(function(composer) { return composer.name })
    .attr("font-family", "Avenir, Open Sans, sans-serif")
    .attr("font-size", function (composer) {
      return composer.importance / 2
    })
    .attr('class', 'composer-name')
    .style('fill', function (composer) {
      if (composer.importance > 40) {
        return '#000000'
      } else if (composer.importance > 30) {
        return '#333333'
      } else if (composer.importance > 20) {
        return '#777777'
      } else {
        return '#AAAAAA'
      }
    })
}

function parseData(dataset) {
  composers = dataset.composers
  earliestBirthYear = dataset.earliest_birth_year
  latestDeathYear = dataset.latest_death_year
  yearsTotal = latestDeathYear - earliestBirthYear

  renderTimeline(25)
  renderTimeline(stageHeight - 25)
  renderEras(50)
  updateGraph(composers)
}

function renderEras(offset) {
  eras = [
    { middle_year: 1250, name: "Medieval", color: eraColor.medieval },
    { middle_year: 1450, name: "Renaissance", color: eraColor.renaissance },
    { middle_year: 1675, name: "Baroque", color: eraColor.baroque },
    { middle_year: 1775, name: "Classical", color: eraColor.classical },
    { middle_year: 1850, name: "Romantic", color: eraColor.romantic },
    { middle_year: 1950, name: "20th Century", color: eraColor.modernist }
  ]
  let svgContainer = d3.select('svg')
  let eraTexts = svgContainer.selectAll("text.era").data(eras)
  eraTexts.enter().append('text')
    .attr('text-anchor', 'middle')
    .attr('x', function(era) { return xForYear(era.middle_year) })
    .attr('y', offset)
    .text(function(era) { return era.name })
    .attr("font-family", "Avenir, Open Sans, sans-serif")
    .attr("font-size", 20)
    .attr('class', 'era')
    .style('fill', function (era) { return era.color })
}

function renderTimeline(offset) {
  let svgContainer = d3.select('svg')
  let sideMargin = 5

  svgContainer.append('line')
    .attr('x1', sideMargin)
    .attr('y1', offset)
    .attr('x2', stageWidth - sideMargin)
    .attr('y2', offset)
    .attr('stroke', '#555555')
    .attr('stroke-width', 1.5)
    .attr('class', 'timeline')

  let elementClass = "century-mark-" + offset
  let dataset = [1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000]
  let centuryMarks = svgContainer.selectAll("line." + elementClass).data(dataset)

  centuryMarks.enter().append('line')
    .attr('x1', function (year) { return xForYear(year) })
    .attr('y1', offset - 5)
    .attr('x2', function (year) { return xForYear(year) })
    .attr('y2', offset + 5)
    .attr('stroke', '#555555')
    .attr('stroke-width', 1)
    .attr('class', elementClass)

  let textElementClass = "century-text-" + offset
  let texts = svgContainer.selectAll('text.' + textElementClass).data(dataset)

  texts.enter().append('text')
    .attr('x', function(year) { return xForYear(year) + 5 })
    .attr('y', offset - 3)
    .text(function(year) { return year })
    .attr("font-family", "Avenir, Open Sans, sans-serif")
    .attr("font-size", 12)
    .attr('class', textElementClass)
}

function xForYear(year) {
  let linearValue = (year - earliestBirthYear) * stageWidth / yearsTotal
  let exponent = 1.3
  let ratio = stageWidth / Math.pow(stageWidth, exponent)
  return Math.pow(linearValue, exponent) * ratio
}

function yForIndex(index) {
  let topMargin = 100
  let bottomMargin = 25
  let height = stageHeight - topMargin - bottomMargin
  let lineHeight = 25
  let columns = Math.floor((index * lineHeight) / height)
  let columnOffset = 0 // (columns % 2) * 2 // lineHeight / 2
  return topMargin + (index * lineHeight) % height + columnOffset
}

d3.json(url, parseData)
