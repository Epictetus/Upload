class UploadFile < ActiveRecord::Base

  @@directory = "public/images"
  attr_accessor :file, :filename

  def initialize(filename="")
    path = File.join(@@directory, filename)
    self.file = File.new(path, "r+")
    self.filename = File.basename(self.file.path)
  end
  
  def self.find(pattern)
    pattern = "" if pattern == :all
    files = Dir.glob(File.join(@@directory, "*")).select{|f| File.file? f}.map{|f| File.basename(f)}
    files = files.select{|f| f.index(pattern)}
    files.map{|f| UploadFile.new(f)}
  end
  
  def self.create(file)
    filename = file.original_filename.gsub(" ", "_")
    path = File.join(@@directory, filename)
    File.open(path, "w+") { |f| f.write(file.read) }
    UploadFile.new(filename)
  end
  
  def delete
    begin
      File.delete(self.file.path)
      return true
    rescue
      return false
    end
  end

end
