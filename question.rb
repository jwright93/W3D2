require_relative 'manifest'

class Question
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    results = author.map do |question|
      Question.new(question)
    end
  end

  def self.most_followed_questions(n)

    followed = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        question_follows.question_id
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      GROUP BY
        question_follows.question_id
      HAVING
        COUNT(question_follows.question_id)
      ORDER BY
        COUNT(question_follows.question_id) DESC
      LIMIT
        ?
    SQL

    results = followed.map do |question|
      Question.find_by_id(question.values[0])
    end
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end 


  attr_accessor  :title, :body, :author_id
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
