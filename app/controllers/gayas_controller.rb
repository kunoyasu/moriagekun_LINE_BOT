class GayasController < ApplicationController
  protect_from_forgery except: :callback

  MARRY = /結婚|結婚式|/
  BITRHDAY = /誕生日|誕生/
  ANOUNCEMENT = /報告|発表/
  DISAPPOINTING = /残念|残念ながら/
  GALD = /嬉しい/


  def callback
    client = Line::Bot::Client.new do |config|
      config.channel_id = Rails.application.credentials.channel_id
      config.channel_secret = Rails.application.credentials.channel_secret
      config.channel_token = Rails.application.credentials.channel_token
    end

    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)
    events.each do |event|
      message = case event
                when Line::Bot::Event::Message
                  { type: 'text', text: parse_message_type(event) }
                else
                  { type: 'text', text: '........' }
                end
      client.reply_message(event['replyToken'], message)
    end
    head :ok
  end

  private
  def parse_message_type(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
      reaction_text(event)
      else
      'Thanks!!'             # ユーザーが投稿したものがテキストメッセージ以外だった場合に返す値
    end
  end

  def reaction_text(event)
    # 誕生日だった場合
    if event.message['text'].match?(BITRHDAY)
      "┈┈┈🔥🔥🔥🔥🔥🔥
┈┈╭┻┻┻┻┻┻┻┻┻╮┈┈
┈┈┃╱╲╱╲╱╲╱╲╱┃┈┈
┈╭┻━━━━━━━━━┻╮┈
┈┃╱╲╱╲╱╲╱╲╱╲╱┃┈
┈┗━━━━━━━━━━━┛┈
🎉🎉HAPPY BIRTHDAY!🎉🎉"
    # 結婚式だった場合
    elsif event.message['text'].match?(ANOUNCEMENT)
     "┏┓┏┳┓ ┏━┓┏┓┏┓
┃┃┗┻┛ ┗━┛┃┃┃┃
┃┗━━┓    ┃┃┃┃
┃┏━━┛    ┃┃┗┛
┃┃    ┏━━┛┃┏┓
┗┛    ┗━━━┛┗┛
      報告とはーー！！？？😳"
    # 残念なお知らせだった場合
    else
      event.message['text'] # 上記２つに合致しない投稿だった場合、投稿と同じ文字列を返す
    end
  end
end
