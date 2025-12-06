class Datalake < Struct.new(:db, :prefix)
  def init!()
    self.db.execute(File.read(Rails.root.join("db", "duckdb.sql")))
  end

  def self.instance=(datalake)
    @@instance = datalake
  end

  def self.instance()
    @@instance
  end
end
