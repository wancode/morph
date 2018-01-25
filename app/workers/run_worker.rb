class RunWorker
  class NoRemainingSlotsError < StandardError
  end

  include Sidekiq::Worker
  # TODO: Make backtrace: true to be a default option for all workers
  sidekiq_options queue: :scraper, backtrace: true

  def perform(run_id)
    run = Run.find_by(id: run_id)
    # If the run has been deleted (the scraper has been deleted) then just
    # skip over this and don't do anything
    if run
      runner = Morph::Runner.new(run)
      if Morph::Runner.available_slots > 0 || runner.container_for_run
        # If this run belongs to a scraper that has just been deleted
        # or if the run has already been marked as finished then
        # don't do anything
        if run.scraper && !run.finished?
          run.scraper.synchronise_repo
          runner.go_with_logging
        end
      else
        # TODO: Don't throw this error if the container for this run already exists
        raise NoRemainingSlotsError
      end
    end
  end
end
