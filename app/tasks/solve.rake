desc 'Assignes taks to teams'
task solve: :env do
  import = Importer.new(
    input: 'inputs/kittens.in'
  ).call

  dataset = {
    videos: import[:videos],
    caches: import[:caches]
  }

  assignments = Solver.new(**dataset).call

  Printer.new(assignments).call
end
