class Department
	 attr_accessor :id, :name

	def self.create_table
		 sql = "CREATE TABLE IF NOT EXISTS departments(id INTEGER PRIMARY KEY, name TEXT)"
		 DB[:conn].execute(sql)
	end

	def self.drop_table
		sql = "DROP TABLE IF EXISTS departments"
		DB[:conn].execute(sql)
	end

	def insert
		sql = "INSERT INTO departments(name) VALUES (?)"
		DB[:conn].execute(sql, name)

		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM departments").flatten[0]
	end
	#
	# def add_course(course)
	# 	course.department_id = id
	# 	add_course.save
	# end


	def self.new_from_db(row)
		dept = Department.new
		dept.id = row[0]
		dept.name = row[1]
		dept
	end

	def self.find_by_name(name)
		sql = "SELECT * FROM departments WHERE name = ?"

		DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first

	end


	def self.find_by_id(id)
		sql = "SELECT * FROM departments WHERE id = ?"
		DB[:conn].execute(sql, id).map {|row| self.new_from_db(row)}.first
	end

def self.find_all_by_department_id(id)
	sql = "SELECT * FROM departments WHERE department_id = ?"
	row = DB[:conn].execute(sql,id).flatten
	self.new_from_db(row)
end

def update
	sql = "UPDATE departments SET name = ? WHERE id = ?"
	DB[:conn].execute(sql, name, id)
end

def persisted? # if the value already exists
	!!self.id
end

def save
	persisted? ? update : insert
end

def courses
		Course.find_all_by_department_id(id)
end
require 'pry'
def add_course(course)
	sql = "INSERT INTO courses(name, department_id) VALUES (?, ?)"
	DB[:conn].execute(sql, course.name, course.id)
	save
end
end
