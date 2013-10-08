require 'util/em-popen3'

module Cocowrite
  module DocumentConverter

    LATEX_TEMPLATE = CONFIG['document']['latex_template']
    TARGET_DIR = CONFIG['document']['target_dir']

    def self.run_pandoc(source, target)
      f = Fiber.current
      status = 'pending'
      log = ''
      p = EM.popen3("pandoc -N --template=#{LATEX_TEMPLATE} --variable mainfont=Georgia --variable sansfont=Arial --variable monofont=Courier --variable fontsize=10pt --variable version=1.10 --latex-engine=xelatex --toc -o #{TARGET_DIR}/#{target}", {
          :stdout => Proc.new { |data| log += data },
          :stderr => Proc.new { |data| log += data }
        })
      p.callback do
        status = 'compilation_succeed'
        f.resume
      end
      p.errback do |err_code|
        status = 'compilation_fail'
        f.resume
      end
      p.send_data_and_close_stdin source
      Fiber.yield
      return [status, log]
    end
  end
end
