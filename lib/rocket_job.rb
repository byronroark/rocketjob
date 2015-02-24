# encoding: UTF-8
require 'mongo'
require 'mongo_ha'
require 'mongo_mapper'
require 'semantic_logger'
require 'symmetric-encryption'
require 'rocket_job/version'

module RocketJob
  autoload :Config,                'rocket_job/config'
  autoload :Heartbeat,             'rocket_job/heartbeat'
  autoload :Job,                   'rocket_job/job'
  autoload :BatchJob,              'rocket_job/batch_job'
  autoload :Server,                'rocket_job/server'
  autoload :Worker,                'rocket_job/worker'
  module Reader
    autoload :Zip,                 'rocket_job/reader/zip'
  end
  module Utility
    autoload :CSVRow,              'rocket_job/utility/csv_row'
  end
  module Writer
    autoload :Zip,                 'rocket_job/writer/zip'
  end
  module Jobs
    autoload :PerformanceJob,      'rocket_job/jobs/performance_job'
  end

  UTF8_ENCODING = Encoding.find("UTF-8").freeze
end
