require_relative 'manifest'

class QuestionFollow
  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless question_follow.length > 0
    QuestionFollow.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    following_users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
      question_id = ?
    SQL
    # return array of User objects
    results = following_users.map do |el|
      User.find_by_id(el.values[0])
    end
  end


  def self.followed_questions_for_user_id(user_id)
    followed_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
      user_id = ?
    SQL
    # return array of Question objects
    results = followed_questions.map do |el|
      Question.find_by_id(el.values[0])
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
