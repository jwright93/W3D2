require_relative 'manifest'

class Reply
  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    results = user.map do |answer|
      Reply.new(answer)
    end
  end

  def self.find_by_question_id(question_id)
    holder = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    results = holder.map do |el|
      Reply.new(el)
    end
  end


  attr_accessor  :user_id, :question_id, :parent_id, :body
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies(id = @id)
    holder = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    results = holder.map do |el|
      Reply.new(el)
    end
  end

end
