class Course
  @@courses = []
  @@last_update = nil
  @course_content

  def set_content(content)
    @course_content = content
  end

  def title
    @course_content.title.split("|").first
  end

  def points
    @course_content.css('.views-field-phpcode').css('.field-content').last.text
  end

  def to_json(options)
    {title: title, points: points}.to_json
  end

  def self.all
    @@courses.to_json
  end

  def to_s
    "#{title} | #{points}"
  end

  def self.add_course(course)
    @@courses << course
  end

  def self.update_if_needed
    if @@last_update.nil? || Time.now - @@last_update > 3600
      self.update
      @@last_update = Time.now
    else
      puts "No update needed yet."
    end
  end

  private

  def self.update
    courses = Nokogiri::HTML(open('http://www.cs.helsinki.fi/courses/'))
    threads = []
    courses.css('a').map do |link|
      href = link.attr('href')
      if href.include? '/courses/'
        course = Course.new
        threads << Thread.new {
          course.set_content(Nokogiri::HTML(open("http://www.cs.helsinki.fi#{href}")))
          puts course
          Course.add_course(course)
        }
      end
    end
    threads.each(&:join)
  end
end