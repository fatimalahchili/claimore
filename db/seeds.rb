########### DESTRUCTION ###########

puts "Clearing existing data... 🧹"

Entry.destroy_all
Claim.destroy_all
Contact.destroy_all
Tenant.destroy_all
Property.destroy_all
User.destroy_all
Admistration.destroy_all

puts "Existing data sweeped out... 🧹✨"


########### CREATION ###########

puts "🌱🌱 Seeding database... 🌱🌱"

##### USER #####

puts "1 - Creating users..."

main_tenant_user = User.find_or_create_by!(email: "main.tenant@claimore.app") do |user|
  user.name = "Joey Tribbian"
  user.password = "password123"
end

sub_tenant_user = User.find_or_create_by!(email: "sub.tenant@claimore.app") do |user|
  user.name = "Phoebe Buffay"
  user.password = "password123"
end

life_partner_user = User.find_or_create_by!(email: "co.tenant@claimore.app") do |user|
  user.name = "Rachel Green"
  user.password = "password123"
end

co_tenant_user = User.find_or_create_by!(email: "life.partner@claimore.app") do |user|
  user.name = "Chandler Bing"
  user.password = "password123"
end

puts "#{User.count} users created\n\n"



##### PROPERTY #####

puts "2 - Creating properties..."

property = Property.find_or_create_by!(address: "Jungstraße 10, 10247, 2nd floor VH 2.OG MR")

puts "#{Property.count} properties created\n\n"



##### TENANT #####

puts "3 - Creating tenants..."

Tenant.find_or_create_by!(user: main_tenant_user, property: property) do |tenant|
  tenant.role = "main_tenant"
end

Tenant.find_or_create_by!(user: sub_tenant_user, property: property) do |tenant|
  tenant.role = "sub_tenant"
end

Tenant.find_or_create_by!(user: co_tenant_user, property: property) do |tenant|
  tenant.role = "co_tenant"
end

Tenant.find_or_create_by!(user: life_partner_user, property: property) do |tenant|
  tenant.role = "life_partner"
end

puts "#{Tenant.count} tenants created\n\n"



##### CONTACT #####

puts "4 - Creating contacts..."

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

puts "#{Contact.count} contacts created\n\n"


##### CLAIM #####

puts "5 - Creating claims..."

claims_data = [
  {
    category: "Mold in bathroom",
    status: "escalated",
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
    status: "open",
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
    status: "resolved",
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
    status: "open",
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
    status: "escalated",
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

puts "#{Claim.count} claims created\n\n"



##### ADMINISTRATION #####

puts "6 - Creating administrations..."

Admistration.find_or_create_by!(name: "Gesundheitsamt Friedrichshain-Kreuzberg") do |admistration|
  admistration.role = "Gesundheitsamt"
  admistration.address = "Curt Bejach Gesundheitshaus, Urbanstraße 24, 10967 Berlin-Bezirk Friedrichshain-Kreuzberg"
  admistration.phone_number = "030 115"
end

puts "#{Admistration.count} administrations created\n\n"



##### LETTER TEMPLATES #####

puts "7 - Creating letter templates..."

Template.find_or_create_by!(name: "Mängelanzeige an Vermieter oder Verwalter") do |template|
  template.description_de = "Formelle Mängelanzeige an den Vermieter oder die Hausverwaltung zur Meldung von Wohnungsmängeln."
  template.description_en = "Formal notice to the landlord or property manager reporting defects in the rented apartment."
  template.instructions_de = "Beschreiben Sie Art, Umfang und Lage des Mangels möglichst genau und setzen Sie eine angemessene Frist zur Behebung. Versenden Sie das Schreiben nachweisbar (z. B. per Einschreiben)."
  template.instructions_en = "Describe the type, extent, and location of the defect as precisely as possible and set a reasonable deadline for repair. Send the letter in a way that can be proven (e.g. registered mail)."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Mängelanzeige für die Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    hiermit möchten wir Ihnen mitteilen, dass in unserer Wohnung seit dem {{defect_date}} folgende(r) Mangel/Mängel besteht/bestehen:

    {{defect_description}}

    Wir bitten Sie, die Beseitigung dieser Mängel möglichst umgehend zu veranlassen. Bitte teilen Sie uns bis zum {{response_deadline}} mit, wann mit der Behebung zu rechnen ist.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "defect_notification",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/maengelanzeige-an-vermieter-oder-verwalter/",
    estimated_length: "150-250 words",
    legal_references: [ "§ 536c BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "defect_date", description: "Date the defect first appeared", type: "date" },
      { variable: "defect_description", description: "Precise description of type, extent, and location of the defect(s)", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should respond", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

Template.find_or_create_by!(name: "Mängelanzeige mit Fristsetzung") do |template|
  template.description_de = "Mängelanzeige mit Fristsetzung zur Mängelbeseitigung und Erklärung der Mietzahlung unter Vorbehalt."
  template.description_en = "Defect notice with a repair deadline and a declaration that rent will be paid under reservation of reclaim."
  template.instructions_de = "Fügen Sie eine detaillierte Mängelliste bei und versenden Sie das Schreiben nachweisbar. Diese Vorlage eignet sich, wenn eine erste Mängelanzeige ohne Reaktion blieb."
  template.instructions_en = "Attach a detailed list of defects and send the letter with proof of delivery. This template is suited for cases where an initial defect notice went unanswered."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Mängelanzeige mit Fristsetzung für die Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    gemäß § 536 c BGB machen wir Ihnen hiermit Anzeige von den jüngst in unserer Wohnung aufgetretenen Mängeln:

    {{defect_description}}

    Wir fordern Sie auf, die Mängel bis zum {{repair_deadline}} zu beseitigen. Sollte dieser Termin nicht eingehalten werden können, bitten wir um umgehende Mitteilung der Gründe.

    Für den Fall, dass die Mängel nicht fristgerecht behoben werden, behalten wir uns vor, einen Handwerker auf Ihre Kosten zu beauftragen (Ersatzvornahme) sowie ggf. ein Sachverständigengutachten einzuholen.

    Gemäß § 536 BGB mindert sich die Miete kraft Gesetzes aufgrund der Gebrauchsbeeinträchtigung. Wir werden die Mietzahlungen ab sofort unter dem Vorbehalt der Rückforderung leisten.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "defect_notification_with_deadline",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/maengelanzeige-mit-fristsetzung-erklaerung-der-vorbehaltszahlung/",
    estimated_length: "200-300 words",
    legal_references: [ "§ 536 BGB", "§ 536c BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "defect_description", description: "Precise description of type, extent, and location of the defect(s)", type: "long_text" },
      { variable: "repair_deadline", description: "Deadline by which the defects must be repaired", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

Template.find_or_create_by!(name: "Betriebskostenabrechnung ist fehlerhaft") do |template|
  template.description_de = "Widerspruch gegen eine fehlerhafte Betriebskosten- oder Heizkostenabrechnung mit Aufforderung zur Belegeinsicht."
  template.description_en = "Objection to an incorrect operating or heating cost statement, requesting access to supporting documents."
  template.instructions_de = "Listen Sie die konkret beanstandeten Punkte der Abrechnung auf (z. B. fehlender Abrechnungszeitraum, nicht nachvollziehbarer Verteilerschlüssel). Die Antwortfrist sollte angemessen sein (ca. 14 Tage)."
  template.instructions_en = "List the specific issues found in the statement (e.g. missing billing period, unclear distribution key). Allow a reasonable response deadline (around 14 days)."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Betriebskostenabrechnung/Heizkostenabrechnung vom {{statement_date}} für die Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    die Abrechnung der Betriebskosten/Heizkosten habe ich erhalten. Bei der Prüfung sind mir folgende Mängel aufgefallen:

    {{billing_issues}}

    Bitte übersenden Sie mir Kopien der entsprechenden Belege (Erstattung der Kopierkosten in Höhe von 0,26 € pro Seite biete ich an) oder vereinbaren Sie mit mir einen Termin zur Einsichtnahme in die Originalunterlagen bis zum {{response_deadline}}.

    Bis zur Vorlage einer ordnungsgemäß erstellten Abrechnung bin ich zur Nachzahlung nicht verpflichtet.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "utility_bill_dispute",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/betriebskostenabrechnung-heizkostenabrechnung-ist-fehlerhaft/",
    estimated_length: "150-250 words",
    legal_references: [ "§ 556 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "statement_date", description: "Date of the operating/heating cost statement", type: "date" },
      { variable: "billing_issues", description: "List of the specific errors or missing information found in the statement", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should respond", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

Template.find_or_create_by!(name: "Kündigung des Mietverhältnisses") do |template|
  template.description_de = "Ordentliche Kündigung des Mietverhältnisses durch den Mieter/die Mieter unter Einhaltung der gesetzlichen Kündigungsfrist."
  template.description_en = "Standard tenant-initiated termination of the lease, observing the statutory notice period."
  template.instructions_de = "Alle im Mietvertrag genannten Mieter müssen eigenhändig unterschreiben. Die gesetzliche Kündigungsfrist beträgt in der Regel drei Monate. Versenden Sie das Schreiben nachweisbar."
  template.instructions_en = "All tenants named in the lease must sign by hand. The statutory notice period is generally three months. Send the letter with proof of delivery."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Kündigung – Mieternummer {{tenant_number}}

    Sehr geehrte Damen und Herren,

    hiermit kündigen wir unseren Mietvertrag über die Wohnung {{property_address}} fristgerecht zum {{termination_date}}.

    Wir bitten Sie, mit uns rechtzeitig Besichtigungstermine für Nachmieter zu vereinbaren, und bitten um schriftliche Bestätigung des Erhalts dieser Kündigung.

    Mit freundlichen Grüßen
    {{tenant_names}}
    [eigenhändige Unterschrift aller Mieter]
  LETTER
  template.metadata = {
    type: "lease_termination",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/kuendigungsschreiben-des-mietverhaeltnisses/",
    estimated_length: "100-150 words",
    legal_references: [ "§ 573c BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "tenant_number", description: "Tenant/contract number, if available", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "termination_date", description: "Date the lease should end, respecting the statutory notice period", type: "date" },
      { variable: "tenant_names", description: "Name(s) of all tenants named in the lease", type: "text" }
    ]
  }
end

Template.find_or_create_by!(name: "Mahnung – Zurückweisung") do |template|
  template.description_de = "Zurückweisung einer unberechtigten Mahnung des Vermieters oder der Hausverwaltung."
  template.description_en = "Rejection of an unjustified payment reminder sent by the landlord or property manager."
  template.instructions_de = "Verweisen Sie auf Ihr vorheriges Schreiben, das den Sachverhalt bereits klärt (z. B. eine bereits erfolgte Zahlung oder eine bestrittene Forderung)."
  template.instructions_en = "Reference your previous letter that already clarifies the matter (e.g. a payment already made or a disputed claim)."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Ihre Mahnung vom {{reminder_date}}

    Sehr geehrte Damen und Herren,

    wir weisen Ihre o. g. Mahnung zurück und beziehen uns dabei auf unser Schreiben vom {{previous_letter_date}}.

    Bitte sehen Sie Ihre Unterlagen durch, und veranlassen Sie die notwendigen Korrekturen, so dass wir künftig nicht mit weiteren Mahnungen behelligt werden.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "payment_reminder_rejection",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/mahnung-zurueckweisung/",
    estimated_length: "50-100 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "reminder_date", description: "Date of the reminder/demand letter being rejected", type: "date" },
      { variable: "previous_letter_date", description: "Date of the tenant's previous letter clarifying the matter", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end


puts "#{Template.count} letter templates created\n\n"

puts "To see things in the seed, that is genius 🌱 — Lao Tzu"
