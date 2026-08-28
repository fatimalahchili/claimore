# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

property = Property.find_or_create_by!(address: "Jungstraße 10, 10247, 2nd floor VH 2.OG MR")

main_tenant_user = User.find_or_create_by!(email: "main.tenant@claimore.app") do |user|
  user.name = "Anna Weber"
  user.password = "password123"
end

sub_tenant_user = User.find_or_create_by!(email: "sub.tenant@claimore.app") do |user|
  user.name = "Jonas Becker"
  user.password = "password123"
end

co_tenant_user = User.find_or_create_by!(email: "co.tenant@claimore.app") do |user|
  user.name = "Laura Fischer"
  user.password = "password123"
end

Tenant.find_or_create_by!(user: main_tenant_user, property: property) do |tenant|
  tenant.role = "main_tenant"
end

Tenant.find_or_create_by!(user: sub_tenant_user, property: property) do |tenant|
  tenant.role = "sub_tenant"
end

Tenant.find_or_create_by!(user: co_tenant_user, property: property) do |tenant|
  tenant.role = "co_tenant"
end

contacts_data = [
  {
    name: "Klaus Meier Sanitär",
    role: "Plumber",
    phone_number: "030 4471 2298",
    email: "kontakt@meier-sanitaer-berlin.de",
    address: "Grünberger Straße 45, 10245 Berlin",
    website: "https://meier-sanitaer-berlin.de"
  },
  {
    name: "Berliner Hausverwaltung GmbH",
    role: "Property management",
    phone_number: "030 8892 1034",
    email: "verwaltung@berliner-hausverwaltung.de",
    address: "Frankfurter Allee 12, 10247 Berlin",
    website: "https://berliner-hausverwaltung.de"
  },
  {
    name: "Elektro Schulz",
    role: "Electrician",
    phone_number: "030 5573 8820",
    email: "info@elektro-schulz-berlin.de",
    address: "Warschauer Straße 33, 10243 Berlin",
    website: "https://elektro-schulz-berlin.de"
  }
]

contacts_data.each do |contact_data|
  Contact.find_or_create_by!(property: property, name: contact_data[:name]) do |contact|
    contact.role = contact_data[:role]
    contact.phone_number = contact_data[:phone_number]
    contact.email = contact_data[:email]
    contact.address = contact_data[:address]
    contact.website = contact_data[:website]
  end
end

claims_data = [
  {
    category: "Mold in bathroom",
    status: "active",
    entries: [
      {
        date: Date.new(2025, 1, 10),
        title: "Mold discovered in the bathroom",
        description: "Tenants noticed black mold spreading across the bathroom ceiling and around the window frame.",
        category: "issue_started",
        status: "reported"
      },
      {
        date: Date.new(2025, 1, 14),
        title: "Landlord informed of the mold",
        description: "Sent a written notice (Mängelanzeige) with photos to the landlord describing the mold and requesting an inspection.",
        category: "landlord_notified",
        status: "pending"
      },
      {
        date: Date.new(2025, 2, 5),
        title: "Reminder sent after no response",
        description: "No response received after three weeks, so a registered letter with a new repair deadline was sent to the landlord.",
        category: "reminder_sent",
        status: "pending"
      },
      {
        date: Date.new(2025, 3, 1),
        title: "Rent reduction announced and Gesundheitsamt contacted",
        description: "Formal notice of Mietminderung (20% rent reduction) sent to the landlord, and the Gesundheitsamt Friedrichshain-Kreuzberg was contacted to request a health inspection of the mold.",
        category: "legal_action",
        status: "escalated"
      }
    ]
  },
  {
    category: "Broken pipe under kitchen sink",
    status: "active",
    entries: [
      {
        date: Date.new(2025, 2, 20),
        title: "Pipe bursts under the kitchen sink",
        description: "A water pipe under the kitchen sink burst, flooding the cabinet and part of the kitchen floor.",
        category: "issue_started",
        status: "reported"
      },
      {
        date: Date.new(2025, 2, 20),
        title: "Landlord informed by phone",
        description: "Landlord was called the same day due to the emergency, followed by a written confirmation email with photos.",
        category: "landlord_notified",
        status: "pending"
      },
      {
        date: Date.new(2025, 2, 25),
        title: "Plumber provides only a temporary fix",
        description: "The landlord's plumber visited and applied a temporary patch, but did not replace the damaged section of pipe.",
        category: "inspection",
        status: "pending"
      },
      {
        date: Date.new(2025, 3, 15),
        title: "Written notice demanding a permanent repair",
        description: "Sent a written notice requesting a permanent repair within two weeks, warning of a rent reduction if the pipe is not properly fixed.",
        category: "legal_action",
        status: "open"
      }
    ]
  },
  {
    category: "Heating failure in winter",
    status: "archived",
    entries: [
      {
        date: Date.new(2024, 12, 5),
        title: "Heating stops working",
        description: "The heating system stopped working in the middle of winter, leaving the flat without warm water and heat.",
        category: "issue_started",
        status: "reported"
      },
      {
        date: Date.new(2024, 12, 5),
        title: "Landlord informed as an emergency",
        description: "Landlord was informed immediately by phone due to the loss of heating in winter, with written confirmation sent the same day.",
        category: "landlord_notified",
        status: "pending"
      },
      {
        date: Date.new(2024, 12, 10),
        title: "Formal Mängelanzeige sent",
        description: "No repair had taken place after five days, so a formal written notice (Mängelanzeige) with a repair deadline was sent.",
        category: "reminder_sent",
        status: "pending"
      },
      {
        date: Date.new(2024, 12, 20),
        title: "Rent reduction announced, heating repaired",
        description: "A Mietminderung (30% rent reduction) for the days without heating was announced, after which the landlord repaired the heating system.",
        category: "legal_action",
        status: "resolved"
      }
    ]
  },
  {
    category: "Cockroach infestation in kitchen",
    status: "active",
    entries: [
      {
        date: Date.new(2025, 4, 2),
        title: "Cockroaches spotted in the kitchen",
        description: "Tenants first spotted cockroaches in the kitchen cabinets and near the stove.",
        category: "issue_started",
        status: "reported"
      },
      {
        date: Date.new(2025, 4, 5),
        title: "Landlord informed in writing",
        description: "Sent a written notice to the landlord describing the infestation and requesting professional pest control.",
        category: "landlord_notified",
        status: "pending"
      },
      {
        date: Date.new(2025, 4, 20),
        title: "Follow-up letter sent",
        description: "No pest control had been arranged after two weeks, so a follow-up letter with a new deadline was sent to the landlord.",
        category: "reminder_sent",
        status: "pending"
      },
      {
        date: Date.new(2025, 5, 10),
        title: "Independent pest control arranged",
        description: "Tenants arranged an independent pest control company and sent the landlord the invoice along with a legal notice requesting reimbursement and a rent reduction.",
        category: "legal_action",
        status: "open"
      }
    ]
  },
  {
    category: "Water damage on living room ceiling",
    status: "active",
    entries: [
      {
        date: Date.new(2025, 5, 15),
        title: "Water stains appear on the ceiling",
        description: "Water stains and damp patches appeared on the living room ceiling after several days of heavy rain.",
        category: "issue_started",
        status: "reported"
      },
      {
        date: Date.new(2025, 5, 16),
        title: "Landlord notified with photos",
        description: "Landlord was notified in writing with photos of the water damage and asked to investigate the cause of the leak.",
        category: "landlord_notified",
        status: "pending"
      },
      {
        date: Date.new(2025, 6, 1),
        title: "Independent damage assessment requested",
        description: "After no response from the landlord, tenants requested an independent assessment of the damage and possible roof leak.",
        category: "inspection",
        status: "pending"
      },
      {
        date: Date.new(2025, 6, 20),
        title: "Legal letter sent via lawyer",
        description: "A formal legal letter was sent through a lawyer, setting a repair deadline and threatening a Mietminderung if the leak is not fixed.",
        category: "legal_action",
        status: "escalated"
      }
    ]
  }
]

claims_data.each do |claim_data|
  claim = Claim.find_or_create_by!(property: property, category: claim_data[:category]) do |c|
    c.status = claim_data[:status]
  end

  claim_data[:entries].each do |entry_data|
    Entry.find_or_create_by!(claim: claim, title: entry_data[:title]) do |entry|
      entry.date = entry_data[:date]
      entry.description = entry_data[:description]
      entry.category = entry_data[:category]
      entry.status = entry_data[:status]
    end
  end
end

Admistration.find_or_create_by!(name: "Gesundheitsamt Friedrichshain-Kreuzberg") do |admistration|
  admistration.role = "Gesundheitsamt"
  admistration.address = "Curt Bejach Gesundheitshaus, Urbanstraße 24, 10967 Berlin-Bezirk Friedrichshain-Kreuzberg"
  admistration.phone_number = "030 115"
end
