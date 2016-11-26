# capybara fragment that generated the .csv

scenario 'get composer results', :js do
  lines = ['page_name,google_results_count']
  COMPOSERS = ["Adrian Willaert", "Alessandro Scarlatti", "Alexander Agricola", "Alfred Schnittke", "Antoine Busnoys", "Anton Bruckner", "Antonio Salieri", "Antonio Soler", "Antonín Dvořák", "Arcangelo Corelli", "Arnold Schoenberg", "Bedrich Smetana", "Benjamin Britten", "Béla Bartók", "Camille Saint-Saëns", "Carl Czerny", "Carl Maria von Weber", "Carl Philip Emmanuel Bach", "Carlo Gesualdo", "Charles Ives", "Christoph Willibald Gluck", "Claude Debussy", "Claudio Monteverdi", "Cristobal de Morales", "César Franck", "Dieterich Buxtehude", "Dmitri Shostakovich", "Dmytro Bortniansky", "Domenico Scarlatti", "Edvard Grieg", "Einojuhani Rautavaara", "Enrique Granados", "Eugène Ysaÿe", "Felix Mendelssohn", "Francisco Guerrero", "Franz Liszt", "Franz Schubert", "François Couperin", "Frederic Chopin", "Gabriel Fauré", "Gaetano Donizetti", "Georg Philipp Telemann", "George Frideric Handel", "Georges Bizet", "Giacomo Puccini", "Gilles Binchois", "Gioacchino Rossini", "Giovanni Battista Pergolesi", "Giovanni Gabrieli", "Giovanni Pierluigi da Palestrina", "Girolamo Frescobaldi", "Giuseppe Torelli", "Giuseppe Verdi", "Guillaume Dufay", "Gustav Mahler", "Hans Werner Henze", "Harrison Birtwistle", "Hector Berlioz", "Heinrich Ignaz Biber", "Heinrich Isaac", "Heinrich Schütz", "Henry Purcell", "Igor Stravinsky", "Jacob Obrecht", "Jacques Offenbach", "Jean Sibelius", "Jean-Baptiste Lully", "Jean-Philippe Rameau", "Johann Christian Bach", "Johann Pachelbel", "Johann Sebastian Bach", "Johannes Brahms", "Johannes Ockeghem", "Johannes Tinctoris", "John Cage", "John Field", "John Taverner", "Joseph Haydn", "Josquin des Prez", "Louis Vierne", "Ludwig van Beethoven", "Manuel de Falla", "Maurice Ravel", "Max Bruch", "Modest Mussorgsky", "Muzio Clementi", "Niccolo Paganini", "Nicolas Gombert", "Nikolai Rimsky-Korsakov", "Olivier Messiaen", "Orlande de Lassus", "Orlando Gibbons", "Paul Hindemith", "Pierre de La Rue", "Pyotr Ilyich Tchaikovsky", "Ralph Vaughan Williams", "Richard Strauss", "Richard Wagner", "Robert Schumann", "Sergei Prokofiev", "Sergei Rachmaninoff", "Thomas Tallis", "Tomaso Albinoni", "Tomás Luis de Victoria", "Verdina Shlonsky", "Vivaldi", "William Byrd", "Witold Lutosławski", "Wolfgang Amadeus Mozart"]
  COMPOSERS.each do |composer|
    visit 'https://www.google.com/'
    fill_in 'q', with: "\"#{composer}\" composer"
    click_button 'Search'
    results_count = page.body.scan(/About\s+(.+?)\s+results/i)
    lines << [composer, results_count[0][0].gsub(',', '_')].join(',')
  end
  puts lines
end
