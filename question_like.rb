require_relative 'manifest'

class QuestionLike
  def self.find_by_id(id)
    question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_like
      WHERE
        id = ?
    SQL
    return nil unless question_like.length > 0
    QuestionLike.new(question_like.first)
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    #return array of Users
    results = likers.map do |el|
      User.find_by_id(el.values[0])
    end
  end

  def self.num_likes_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(question_id)
      FROM
        question_likes
      WHERE
        question_id = ?

    SQL
    #return number of likes
    likers.first.values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    liked = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
    #return array of Users
    results = liked.map do |el|
      Question.find_by_id(el.values[0])
    end
  end

  def self.most_liked_questions(n)
    liked = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        question_likes.question_id
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      GROUP BY
        question_likes.question_id
      HAVING
        COUNT(question_likes.question_id)
      ORDER BY
        COUNT(question_likes.question_id) DESC
      LIMIT
        ?
    SQL

    results = liked.map do |question|
      Question.find_by_id(question.values[0])
    end
  end


  attr_accessor  :user_id, :question_id
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
