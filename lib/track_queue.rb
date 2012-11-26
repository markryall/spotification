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
      File.open(Time.now.to_i.to_s, 'w') {|f| f.print track.to_yaml }
    end
  end

  def destroy id
    in_queue_dir { FileUtils.rm id }
  end

  def dequeue
    in_queue_dir do
      file = Dir.glob('*').sort.first
      return nil unless file
      hash = YAML.load_file file
      FileUtils.rm file
      hash
    end
  end

  def each_track
    in_queue_dir do
      Dir.glob('*').sort.each do |file|
        yield YAML.load_file file
      end
    end
  end
end