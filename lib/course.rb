require 'pry'
class Course
  attr_accessor :id, :name, :department_id

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS courses (
      id INTEGER PRIMARY KEY,
      name TEXT,
      department_id INTEGER REFERENCES departments
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
   sql = <<-SQL
   DROP TABLE IF EXISTS courses
   SQL
   DB[:conn].execute(sql)
 end
require 'pry'
  def insert
    sql = <<-SQL
    INSERT INTO courses (name, department_id) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.department_id)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM courses").flatten[0]
#return info from database as an object of the class
#@id = self.class.find_by_name(self.name).id
    #why are we setting id =?
  end

require 'pry'
  def self.new_from_db(row)
     new_course = self.new
     new_course.id = row[0]
     new_course.name = row[1]
     new_course.department_id = row[2]
     new_course
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM courses WHERE name = ?
    SQL
    results = DB[:conn].execute(sql, name)
    results.map {|row| self.new_from_db(row)}.first

  end

  def self.find_all_by_department_id(self_id)
    sql = <<-SQL
      SELECT * FROM courses WHERE department_id = ?
    SQL

    results = DB[:conn].execute(sql, self_id)
    results.map {|row| self.new_from_db(row)}

  end
require 'pry'

def department
  Department.find_by_id(department_id)
end
require 'pry'

def department=(department)
  @department = department
  @department_id = department.id

end

  def update
    sql = <<-SQL
      UPDATE courses
      SET name=?, department_id=?
      WHERE id=?

    SQL
    DB[:conn].execute(sql, self.name, self.department_id, self.id)
  end

  def persisted?
    !!id
  end

  def save
    if persisted? ? update : insert
  end
end

def students
  sql = "SELECT *
  FROM students
  JOIN registrations
  ON students.id = registrations.student_id
  WHERE registrations.course_id = ?"


  DB[:conn].execute(sql, id).map do |row|
      Student.new_from_db(row)
  end
end


require 'pry'
def add_student(student)
  sql = "INSERT INTO registrations (course_id, student_id) VALUES (?,?)"
  DB[:conn].execute(sql, self.id, student.id)

end
end
