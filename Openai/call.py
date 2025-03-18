from openai import OpenAI

client = OpenAI(api_key='OPENAI-KEY')

def call_gpt(message):
    completion = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=message
    )

    return completion.choices[0].message.content, completion.usage.total_tokens

def call_template_gpt(message, template):
    completion = client.beta.chat.completions.parse(
    model="gpt-4o",
    messages=message,
    response_format=template,
)
    return completion.choices[0].message.parsed, completion.usage.total_tokens
