require 'fileutils'
require 'yaml'

module TrackQueue
  def in_queue_dir
    queue_path = 'queue'
    FileUtils.mkdir_p queue_path
    Dir.chdir(queue_path) { yield }
  end

  def enqueue track
    in_queue_dir do
      @sequence ||= 0
      File.open("#{Time.now.to_i}-#{@sequence.to_s.rjust(8,'0')}.song", 'w') {|f| f.print track.to_yaml }
    end
  end

  def dequeue
    in_queue_dir do
      file = Dir.glob('*.song').sort.first
      return nil unless file
      hash = YAML.load_file file
      FileUtils.rm file
      hash
    end
  end

  def each_track
    in_queue_dir do
      Dir.glob('*.song').sort.each do |file|
        yield YAML.load_file file
      end
    end
  end
end