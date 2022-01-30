class GayasController < ApplicationController
  protect_from_forgery except: :callback

  MARRY = /結婚|結婚式|/
  BITRHDAY = /誕生日|誕生/
  ANOUNCEMENT = /報告|発表/
  DISAPPOINTING = /残念|残念ながら/
  GLAD = /おめでとう/
  PRAY = /祈願|祈る/

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
🎉🎉HAPPY BIRTHDAY!🎉🎉
誕生日おめでとうな！！"
    # 結婚式だった場合
    elsif event.message['text'].match?(MARRY)
      "┈┈┈🔥🔥🔥🔥🔥🔥
┈┈╭┻┻┻┻┻┻┻┻┻╮┈┈
┈┈┃╱╲╱╲╱╲╱╲╱┃┈┈
┈╭┻━━━━━━━━━┻╮┈
┈┃╱╲╱╲╱╲╱╲╱╲╱┃┈
┈┗━━━━━━━━━━━┛┈
🎉🎉HAPPY WEDING!🎉🎉
結婚おめでとうな！！"
    elsif event.message['text'].match?(ANOUNCEMENT)
     "┏┓┏┳┓ ┏━┓┏┓┏┓
┃┃┗┻┛ ┗━┛┃┃┃┃
┃┗━━┓    ┃┃┃┃
┃┏━━┛    ┃┃┗┛
┃┃    ┏━━┛┃┏┓
┗┛    ┗━━━┛┗┛
      報告とはーー！！？？😳"
    # 残念なお知らせだった場合
    elsif event.message['text'].match?(DISAPPOINTING)
      "    _
   / )
|￣|／ └┐
| |   ｜正直は正義だ🦸‍
|＿|―､＿ﾉ"
    elsif event.message['text'].match?(GLAD)
       "　　お
            め
                で
                    と
                    ぅ
                  ぅ
                ぅ
                ぅ
                ぅ
                🎉
        (\(\
\(๑ˊ∇ˋ)/"
    elsif event.message['text'].match?(PRAY)
      " 　  ⋀_⋀　 
　  (･ω･)  
／ Ｕ ∽ Ｕ ＼ 
│＊　 成　＊│ 
│＊　 功　＊│ 
│＊　 祈　＊│ 
│＊　 願　＊│ 
│＊　 🤝　＊│ 
.￣￣￣￣￣
オジサンも成功祈ってるぞ！！
"
    end
  end
end
