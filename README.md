# Claimore

**Claimore helps you understand, organize, and take action on your claims — without the paperwork headache.**

From uploading documents to generating letters and keeping track of your case, Claimore brings the claim process into one simple workspace.

## ✨ What Claimore Does

Claimore is designed to help users navigate claims without having to figure everything out on their own.

Users can manage their claim, upload relevant documents, generate useful documents and letters, and get AI-powered assistance throughout the process.

### Key Features

- 🤖 **AI-powered claim assistance**  
  Get help understanding and navigating your claim.

- 📁 **Claim management**  
  Keep claim information and progress organized in one place.

- 📄 **Document handling**  
  Upload and manage documents related to a claim.

- ✍️ **Letter & PDF generation**  
  Generate documents that can be used throughout the claims process.

- 📧 **Email integration**  
  Send claim-related communication directly through the application.

- 🔐 **User authentication**  
  Secure personal accounts and claim data.

- 🧠 **RAG & embeddings**  
  Retrieve relevant information to provide more contextual AI assistance.

## 🛠 Tech Stack

**Backend**
- Ruby on Rails 8
- PostgreSQL
- RubyLLM
- Active Record
- Devise

**Frontend**
- Hotwire
- Turbo
- Stimulus
- Bootstrap
- SCSS

**AI**
- RubyLLM
- Vector embeddings
- RAG (Retrieval-Augmented Generation)

**Storage & Documents**
- Active Storage
- Cloudinary
- Wicked PDF

**Other**
- Action Mailer
- QR Code generation
- Docker / Kamal
- Git & GitHub

## 🧠 How It Works

Claimore combines a traditional Rails application with AI-powered tools.

Claim information and uploaded documents provide context that can be used by the application's AI features. Retrieval and embeddings allow relevant information to be surfaced when needed, helping generate more useful and contextual responses instead of relying only on a generic AI conversation.

The application is structured around dedicated agents, prompts, services, and tools, keeping the AI functionality separate and maintainable as the project grows.

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/fatimalahchili/claimore.git
cd claimore
```

Install the dependencies:

```bash
bundle install
```

Set up the database:

```bash
rails db:create
rails db:migrate
rails db:seed
```

Add the required environment variables to your local `.env` file.

Then start the application:

```bash
bin/dev
```

Open:

`http://localhost:3000`

## 🔒 Environment Variables

Claimore uses environment variables for external services and credentials.

Create a `.env` file locally and add the credentials required by the application.

**Never commit your `.env` file or API keys to the repository.**

## 💭 Why Claimore?

Claims can quickly become confusing: documents are scattered, deadlines matter, communication needs to be tracked, and understanding what to do next isn't always obvious.

Claimore aims to make that process easier by combining organization, document management, automation, and AI assistance in one place.

---

Built with Ruby on Rails, a questionable amount of debugging, and the belief that dealing with a claim shouldn't be harder than the claim itself.
