########### DESTRUCTION ###########

puts "Clearing existing data... 🧹"

puts "-------------------------"
puts "-------------------------"

Entry.destroy_all
Claim.destroy_all
Contact.destroy_all
Tenant.destroy_all
Property.destroy_all
User.destroy_all
Administration.destroy_all
Template.destroy_all

puts "Existing data sweeped out... 🧹✨"
puts "-------------------------"

########### CREATION ###########

puts "🌱🌱 Seeding database... 🌱🌱"
puts "-------------------------"


##### USER #####

puts "1 - Creating users..."
puts "-------------------------"

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

puts "➔ #{User.count} users created\n\n"
puts "-------------------------"
puts "-------------------------"



##### PROPERTY #####

puts "2 - Creating properties..."
puts "-------------------------"

property = Property.find_or_create_by!(address: "Jungstraße 10, 10247, 2nd floor VH 2.OG MR")

puts "➔ #{Property.count} properties created\n\n"
puts "-------------------------"
puts "-------------------------"


##### TENANT #####

puts "3 - Creating tenants..."
puts "-------------------------"

Tenant.find_or_create_by!(user: main_tenant_user, property: property) do |tenant|
  tenant.role = "main_tenant"
  tenant.status = "tenant"
end

Tenant.find_or_create_by!(user: sub_tenant_user, property: property) do |tenant|
  tenant.role = "sub_tenant"
  tenant.status = "tenant"
end

Tenant.find_or_create_by!(user: co_tenant_user, property: property) do |tenant|
  tenant.role = "co_tenant"
  tenant.status = "tenant"
end

Tenant.find_or_create_by!(user: life_partner_user, property: property) do |tenant|
  tenant.role = "life_partner"
  tenant.status = "tenant"
end

puts "➔ #{Tenant.count} tenants created\n\n"
puts "-------------------------"
puts "-------------------------"


##### CONTACT #####

puts "4 - Creating contacts..."
puts "-------------------------"

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

puts "➔ #{Contact.count} contacts created\n\n"
puts "-------------------------"
puts "-------------------------"


##### CLAIM #####

puts "5 - Creating claims..."
puts "-------------------------"

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
    status: "archived",
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
    status: "archived",
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

puts "➔ #{Claim.count} claims created\n\n"
puts "-------------------------"
puts "-------------------------"



##### ADMINISTRATION #####

puts "6 - Creating administrations..."
puts "-------------------------"

Administration.find_or_create_by!(name: "Gesundheitsamt Friedrichshain-Kreuzberg") do |administration|
  administration.role = "Gesundheitsamt"
  administration.address = "Curt Bejach Gesundheitshaus, Urbanstraße 24, 10967 Berlin-Bezirk Friedrichshain-Kreuzberg"
  administration.phone_number = "030 115"
end

puts "➔ #{Administration.count} administrations created\n\n"
puts "-------------------------"
puts "-------------------------"


##### LETTER TEMPLATES #####

puts "7 - Creating letter templates..."
puts "-------------------------"

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

# Row 1: Asbest in Wohnräumen – Auskunftsanspruch
Template.find_or_create_by!(name: "Asbest in Wohnräumen – Auskunftsanspruch") do |template|
  template.description_de = "Auskunftsverlangen an den Vermieter oder die Hausverwaltung, ob und in welcher Weise die Wohnung asbesthaltige Baustoffe enthält."
  template.description_en = "Request to the landlord or property manager for information on whether, and how, the apartment contains asbestos-containing building materials."
  template.instructions_de = "Passen Sie die Formulierungen an Ihren konkreten Fall an; ein Mustertext kann nicht jeden erdenklichen Fall widerspiegeln. Versenden Sie das Schreiben nachweisbar."
  template.instructions_en = "Adapt the wording to your specific situation; a template cannot reflect every possible case. Send the letter in a way that can be proven (e.g. registered mail)."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Sehr geehrte Damen und Herren,

    wir fordern Sie auf, uns bis zum {{response_deadline}} Auskunft darüber zu erteilen, ob und gegebenenfalls in welcher Weise unsere Wohnung {{property_address}} asbesthaltige Baustoffe enthält.

    Rein vorsorglich weisen wir darauf hin, dass – falls in der Wohnung eine latente bzw. akute Asbestbelastung vorliegen sollte – Sie verpflichtet sind, diesbezügliche gesundheitsgefährdende Mängel unverzüglich und fachgerecht beseitigen zu lassen.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "asbestos_information_request",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/asbest-in-wohnraeumen-auskunftsanspruch/",
    estimated_length: "50-100 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should provide the requested information", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 2: Asbest in Wohnräumen – Mängelbeseitigungsanspruch
Template.find_or_create_by!(name: "Asbest in Wohnräumen – Mängelbeseitigungsanspruch") do |template|
  template.description_de = "Mängelanzeige und Aufforderung an den Vermieter zur fachgerechten Beseitigung nachweislich asbestbelasteter Bauteile in der Wohnung."
  template.description_en = "Defect notice demanding that the landlord properly remove building components in the apartment that are proven to contain asbestos."
  template.instructions_de = "Benennen Sie die betroffenen Bauteile so genau wie möglich (z. B. Bodenbeläge, Fensterbänke, Heizkörper-Nachtspeicheröfen) und setzen Sie eine angemessene Frist. Versenden Sie das Schreiben nachweisbar."
  template.instructions_en = "Name the affected building components as precisely as possible (e.g. flooring, window sills, night storage heaters) and set a reasonable deadline. Send the letter in a way that can be proven."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Asbestbelastung in der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    hiermit zeigen wir an, dass folgende Bauteile/Ausstattung unserer Wohnung nachweislich asbestbelastet sind:

    {{affected_components}}

    Die damit verbundene potenzielle bzw. akute Gesundheitsgefährdung ist bekannt und bedarf insofern keiner gesonderten Begründung.

    Wir fordern Sie auf, bis spätestens zum {{repair_deadline}} für eine fachgerechte und nachhaltige Mängelbeseitigung zu sorgen.

    Bitte teilen Sie mit, ob und gegebenenfalls in welcher Weise Sie dazu unserer Mitwirkung bedürfen. Sollte die Wohnung während der Asbestsanierung nur eingeschränkt bzw. gar nicht nutzbar sein, bitten wir um Mitteilung, ob Sie angemessene Ausweichmöglichkeiten zur Verfügung stellen werden.

    Schadensersatzansprüche bleiben ausdrücklich vorbehalten.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "asbestos_remediation_demand",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/asbest-in-wohnraeumen-maengelbeseitigungsanspruch/",
    estimated_length: "150-200 words",
    legal_references: [ "§ 535 Abs. 1 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "affected_components", description: "List of the specific building components/fixtures proven to contain asbestos", type: "long_text" },
      { variable: "repair_deadline", description: "Deadline by which the remediation must be carried out", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 3: Aufnahme eines Lebensgefährten
Template.find_or_create_by!(name: "Aufnahme eines Lebensgefährten") do |template|
  template.description_de = "Mitteilung an den Vermieter über den geplanten Einzug des Lebensgefährten/der Lebensgefährtin und Aufforderung zur Erteilung der Erlaubnis."
  template.description_en = "Notice to the landlord about a partner's planned move-in, requesting the landlord's permission to add them to the household."
  template.instructions_de = "Kündigen Sie den Einzug möglichst mit einem Vorlauf von ca. sechs Wochen an und setzen Sie dem Vermieter eine Frist von ca. vier Wochen zur Erteilung der Erlaubnis."
  template.instructions_en = "Announce the move-in with roughly six weeks' notice and give the landlord about four weeks to grant permission."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Sehr geehrte Damen und Herren,

    hiermit möchte ich Sie darüber informieren, dass mein Lebensgefährte/meine Lebensgefährtin, {{partner_name}}, zum {{move_in_date}} bei mir einziehen wird.

    {{partner_name}} wohnt derzeit in {{partner_current_address}}.

    Nach der Rechtsprechung des BGH (Urteil vom 05.11.2003 – VIII ZR 371/02) haben Mieter einen Anspruch auf Erteilung der Erlaubnis des Vermieters zur Aufnahme eines Dritten in die gemietete Wohnung, wenn sie eine nichteheliche Gemeinschaft begründen wollen. So ist es in meinem Fall.

    Ich darf Sie daher auffordern, mir diese Erlaubnis bis zum {{response_deadline}} zu erteilen.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "partner_move_in_permission",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/aufnahme-eines-lebensgefaehrten/",
    estimated_length: "100-150 words",
    legal_references: [ "§ 553 BGB", "BGH, Urteil vom 05.11.2003 – VIII ZR 371/02" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "partner_name", description: "Full name of the partner moving in", type: "text" },
      { variable: "move_in_date", description: "Planned move-in date (ideally ~6 weeks out)", type: "date" },
      { variable: "partner_current_address", description: "Partner's current address", type: "text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should grant permission (ideally ~4 weeks out)", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 4: Balkonsolarkraftwerk – Erlaubnis zur Anbringung eines Steckersolargeräts am/auf dem Balkon.
Template.find_or_create_by!(name: "Balkonsolarkraftwerk – Erlaubnis zur Anbringung eines Steckersolargeräts am/auf dem Balkon.") do |template|
  template.description_de = "Bitte um Erlaubnis des Vermieters zur Anbringung eines Steckersolargeräts (Balkonkraftwerk) am oder auf dem Balkon."
  template.description_en = "Request for the landlord's permission to install a plug-in balcony solar device (\"Balkonkraftwerk\") on or at the balcony."
  template.instructions_de = "Geben Sie die technischen Details des Geräts an (Wechselrichter, Wattleistung, Befestigungsart) und setzen Sie dem Vermieter eine Frist von ca. vier Wochen."
  template.instructions_en = "Provide the technical details of the device (inverter, wattage, mounting method) and give the landlord roughly four weeks to respond."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Anbringung eines Steckersolargeräts an der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    ich beabsichtige, an meinem Balkon ein Steckersolargerät (Balkonkraftwerk) anzubringen. Technische Angaben zum Gerät:

    {{device_details}}

    Nach § 554 BGB kann der Mieter verlangen, dass ihm der Vermieter bauliche Veränderungen erlaubt, die der Stromerzeugung durch Steckersolargeräte dienen. Das Gewicht eines solchen Geräts ist mit dem eines gefüllten Blumenkastens vergleichbar, eine erhöhte Brandgefahr besteht nicht, und die Blendwirkung liegt unterhalb der relevanten Grenzwerte. Die Interessenabwägung fällt daher regelmäßig zugunsten der Mieter:innen aus.

    Ich bitte Sie, mir die Erlaubnis zur Anbringung bis zum {{response_deadline}} zu erteilen.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "balcony_solar_device_permission",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/balkonsolarkraftwerk/",
    estimated_length: "150-200 words",
    legal_references: [ "§ 554 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "device_details", description: "Technical details of the device (inverter, wattage, mounting method)", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should respond (ideally ~4 weeks out)", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 6: Kaution – Alternative zur Barkaution
Template.find_or_create_by!(name: "Kaution – Alternative zur Barkaution") do |template|
  template.description_de = "Vorschlag an den Vermieter, die gezahlte Kaution auf ein gesondertes, auf den Mieter laufendes Sparbuch anzulegen und dieses an den Vermieter zu verpfänden, um den pauschalen Zinsabzug zu vermeiden."
  template.description_en = "Proposal to the landlord to place the paid deposit into a separate savings account in the tenant's name, pledged to the landlord, to avoid the flat-rate tax withholding on interest."
  template.instructions_de = "Diese Vorlage eignet sich, wenn die Kaution derzeit auf den Namen des Vermieters angelegt ist. Musterformulare für die Verpfändung sind bei jeder Bank/Sparkasse erhältlich."
  template.instructions_en = "This template is suited for cases where the deposit is currently held in the landlord's name. Standard pledge forms are available from any bank."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Sehr geehrte Damen und Herren,

    wie Ihnen bekannt ist, haben wir zu Beginn des Mietverhältnisses eine Kaution an Sie entrichtet.

    Da die Kaution auf Ihren Namen angelegt ist, besteht weder für Sie noch für uns die Möglichkeit, einen Freistellungsauftrag zu erteilen. Dies führt dazu, dass von den anfallenden Zinsen jeweils 25 % plus 5,5 % Solidaritätszuschlag pauschal abgezogen werden.

    Wie wir erfahren haben, ist es grundsätzlich möglich, die Kaution auf einem gesonderten Sparbuch auf unseren Namen anzulegen und dieses Sparbuch dann an Sie zu verpfänden. Dadurch hätten wir die Möglichkeit, einen Freistellungsauftrag für den Kautionsbetrag zu erteilen, so dass kein Zinsabzug mehr vorgenommen würde.

    Die Banken und Sparkassen haben für diese Form der Anlage, die für Sie keine Nachteile beinhaltet, Musterformulare entwickelt, die bei jeder Bank erhältlich sind.

    Wir bitten Sie zu prüfen, ob die Kaution nicht besser in dieser Form angelegt werden sollte.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "deposit_savings_account_pledge_proposal",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/kaution-alternative-zur-barkaution/",
    estimated_length: "150-200 words",
    legal_references: [ "§ 551 Abs. 3 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 7: Kaution – Insolvenzsichere Anlage
Template.find_or_create_by!(name: "Kaution – Insolvenzsichere Anlage") do |template|
  template.description_de = "Aufforderung an den Vermieter, die Anlage der Kaution auf einem insolvenzsicheren, von seinem eigenen Vermögen getrennten Konto nachzuweisen, mit Androhung eines Zurückbehaltungsrechts."
  template.description_en = "Demand that the landlord provide proof that the deposit is held in an insolvency-proof account, separate from the landlord's own assets, with notice of a right to withhold rent otherwise."
  template.instructions_de = "Legen Sie eine Kopie des Mietvertrages und der Kautionsquittung bei. Setzen Sie eine angemessene Frist zum Nachweis der insolvenzsicheren Anlage."
  template.instructions_en = "Enclose a copy of the lease and the deposit receipt. Set a reasonable deadline for proof of the insolvency-proof account."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Sehr geehrte Damen und Herren,

    hiermit teile ich Ihnen mit, dass ich am {{lease_start_date}} einen Mietvertrag mit {{landlord_name}} abgeschlossen und eine Mietsicherheit in Höhe von {{deposit_amount}} Euro entrichtet habe.

    Nach § 551 BGB ist die Kaution getrennt von Ihrem Vermögen und insolvenzsicher anzulegen. Ich bitte Sie, mir bis zum {{response_deadline}} schriftlich nachzuweisen, dass die Kaution entsprechend angelegt wurde. Bitte fügen Sie eine Fotokopie des Mietvertrages und der Quittung bei.

    Sollte der Nachweis nicht fristgerecht erbracht werden, mache ich Sie darauf aufmerksam, dass mir gemäß § 273 BGB ein Zurückbehaltungsrecht an den Mietzahlungen bis zur Höhe der Kaution nebst Zinsen zusteht.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "deposit_insolvency_proof_request",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/kaution-insolvenzsichere-anlage/",
    estimated_length: "100-150 words",
    legal_references: [ "§ 551 BGB", "§ 273 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "lease_start_date", description: "Date the lease was signed", type: "date" },
      { variable: "landlord_name", description: "Name of the landlord as stated in the lease", type: "text" },
      { variable: "deposit_amount", description: "Amount of the deposit paid, in EUR", type: "text" },
      { variable: "response_deadline", description: "Deadline by which the landlord must prove the insolvency-proof account", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 8: Kaution – Rueckzahlung der Kaution vom Vermieter fordern
Template.find_or_create_by!(name: "Kaution – Rueckzahlung der Kaution vom Vermieter fordern") do |template|
  template.description_de = "Aufforderung an den ehemaligen Vermieter zur Rückzahlung der Kaution samt Zinsen nach ordnungsgemäßer Wohnungsübergabe und Ablauf der Abrechnungsfrist."
  template.description_en = "Demand to the former landlord for repayment of the deposit plus interest after proper handover of the apartment and expiry of the settlement period."
  template.instructions_de = "Diese Vorlage eignet sich, wenn das Mietverhältnis seit mehr als sechs Monaten beendet ist, die Wohnung ordnungsgemäß übergeben wurde und der Vermieter keine Forderungen erhoben hat. Sechs Monate gelten in der Rechtsprechung regelmäßig als angemessene Prüffrist, sind aber keine feste gesetzliche Frist."
  template.instructions_en = "This template is suited for cases where the tenancy ended more than six months ago, the apartment was handed over properly, and the landlord has raised no claims. Courts generally treat six months as a reasonable review period, though it is not a fixed statutory deadline."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Sehr geehrte Damen und Herren,

    das ehemals zwischen uns bestehende Mietverhältnis über die Wohnung unter folgender Anschrift:

    {{property_address}}

    ist seit dem {{termination_date}} beendet, also seit mehr als sechs Monaten.

    Da einerseits die Wohnung von uns ordnungsgemäß übergeben wurde und andererseits von Ihnen keine Forderungen erhoben wurden, fordern wir Sie auf, die hinterlegte Kaution in Höhe von {{deposit_amount}} Euro einschließlich Zins und Zinseszins bis zum {{repayment_deadline}} an folgende Bankverbindung zurückzuzahlen:

    Kreditinstitut: {{bank_name}}
    IBAN: {{iban}}
    Kontoinhaber: {{account_holder}}

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "deposit_repayment_demand",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/kaution-rueckzahlung-der-kaution-vom-vermieter-fordern/",
    estimated_length: "100-150 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the (former) landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the (former) landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the formerly rented apartment", type: "text" },
      { variable: "termination_date", description: "Date the tenancy ended", type: "date" },
      { variable: "deposit_amount", description: "Amount of the deposit paid, in EUR", type: "text" },
      { variable: "repayment_deadline", description: "Deadline by which the deposit should be repaid", type: "date" },
      { variable: "bank_name", description: "Name of the tenant's bank", type: "text" },
      { variable: "iban", description: "Tenant's IBAN for repayment", type: "text" },
      { variable: "account_holder", description: "Name of the bank account holder", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end
# Row 11: Mängelanzeige – Letzte Mahnung
Template.find_or_create_by!(name: "Mängelanzeige – Letzte Mahnung") do |template|
  template.description_de = "Letzte Mahnung an den Vermieter zur Mängelbeseitigung, bevor weitere rechtliche Schritte eingeleitet werden."
  template.description_en = "Final reminder to the landlord to fix reported defects before further legal action is taken."
  template.instructions_de = "Verwenden Sie dieses Schreiben erst, wenn eine frühere Mängelanzeige unbeantwortet blieb. Setzen Sie eine letzte, angemessene Frist und versenden Sie das Schreiben nachweisbar."
  template.instructions_en = "Use this letter only after an earlier defect notice went unanswered. Set one final, reasonable deadline and send the letter with proof of delivery."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Mängelanzeige für die Wohnung {{property_address}} – letzte Mahnung

    Sehr geehrte Damen und Herren,

    bereits mit Schreiben vom {{previous_notice_date}} haben wir Ihnen die folgenden Mängel an unserem Mietobjekt angezeigt:

    {{defect_description}}

    Da die Mängel bis heute nicht behoben wurden, setzen wir Ihnen nunmehr eine letzte Frist zur Mängelbeseitigung bis zum {{final_deadline}}.

    Wir machen Sie hiermit darauf aufmerksam, dass wir vor Ergreifen weiterer rechtlicher Schritte keine weitere Mahnung mehr übersenden werden.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "defect_notification_final_warning",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/maengelanzeige-letzte-mahnung/",
    estimated_length: "100-150 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "previous_notice_date", description: "Date of the earlier defect notice that went unanswered", type: "date" },
      { variable: "defect_description", description: "Description of the still-unresolved defect(s)", type: "long_text" },
      { variable: "final_deadline", description: "Final deadline given for the defects to be repaired", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 14: Mietaufhebungsvereinbarung – Mustervorlage
Template.find_or_create_by!(name: "Mietaufhebungsvereinbarung – Mustervorlage") do |template|
  template.description_de = "Mustervorlage für eine einvernehmliche Aufhebungsvereinbarung zur vorzeitigen Beendigung des Mietverhältnisses."
  template.description_en = "Template for a mutual termination agreement ending the lease early by agreement between landlord and tenant."
  template.instructions_de = "Diese Vorlage ist weder verbindlich noch vollständig und muss an den Einzelfall angepasst werden. Klären Sie insbesondere die Rückgabe der Kaution, die Übernahme von Schönheitsreparaturen und etwaige Ausgleichszahlungen individuell."
  template.instructions_en = "This template is neither mandatory nor complete and must be adapted to your specific case. In particular, clarify the return of the deposit, responsibility for cosmetic repairs, and any compensation payments individually."
  template.content = <<~LETTER
    Mietaufhebungsvereinbarung

    zwischen {{landlord_name}}, {{landlord_address}} (nachfolgend „Vermieter")
    und {{tenant_names}}, {{property_address}} (nachfolgend „Mieter")

    über die Wohnung {{property_address}}.

    1. Das Mietverhältnis wird im gegenseitigen Einvernehmen voraussichtlich zum {{intended_termination_date}}, spätestens jedoch zum {{final_termination_date}} aufgehoben.

    2. Der Vermieter verzichtet auf die Durchführung von Schönheitsreparaturen durch den Mieter.

    3. Die vom Mieter geleistete Mietsicherheit wird bis zum {{deposit_return_date}} zurückerstattet.

    4. {{compensation_terms}}

    5. Mit Erfüllung dieser Vereinbarung sind alle gegenseitigen Ansprüche aus dem Mietverhältnis abgegolten, soweit hier nicht ausdrücklich etwas anderes vereinbart ist.

    {{property_address}}, den {{date}}

    ______________________          ______________________
    Vermieter                        Mieter
  LETTER
  template.metadata = {
    type: "lease_termination_agreement",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/mietaufhebungsvereinbarung-mustervorlage/",
    estimated_length: "150-200 words",
    legal_references: [],
    required_fields: [
      { variable: "landlord_name", description: "Name of the landlord", type: "text" },
      { variable: "landlord_address", description: "Address of the landlord", type: "text" },
      { variable: "tenant_names", description: "Name(s) of all tenants named in the lease", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "intended_termination_date", description: "Intended date the tenancy should end", type: "date" },
      { variable: "final_termination_date", description: "Latest date by which the tenancy will end at the latest", type: "date" },
      { variable: "deposit_return_date", description: "Date by which the deposit will be returned", type: "date" },
      { variable: "compensation_terms", description: "Any agreed compensation for tenant improvements, moving costs, or other claims", type: "long_text" },
      { variable: "date", description: "Date the agreement is signed", type: "date" }
    ]
  }
end

# Row 15: Mietpreisbremse – Rüge des Mieters wegen Verstoßes
Template.find_or_create_by!(name: "Mietpreisbremse – Rüge des Mieters wegen Verstoßes") do |template|
  template.description_de = "Rüge des Mieters gegenüber dem Vermieter wegen eines Verstoßes gegen die Mietpreisbremse und Aufforderung zur Bestätigung der zulässigen Miete."
  template.description_en = "Tenant's formal complaint to the landlord over a rent-brake violation, requesting confirmation of the legally permissible rent."
  template.instructions_de = "Ermitteln Sie zunächst die ortsübliche Vergleichsmiete (z. B. über den Mietspiegel) und berechnen Sie die zulässige Miete inklusive 10 %-Zuschlag. Beachten Sie, dass Rückforderungsansprüche erst ab Zugang dieser Rüge entstehen (bei Mietverträgen ab dem 1. April 2020 mit Rückwirkung von bis zu 30 Monaten)."
  template.instructions_en = "First determine the local comparable rent (e.g. via the Mietspiegel) and calculate the permissible rent including the 10% surcharge. Note that reimbursement claims generally only arise from the date this notice is received (for leases from 1 April 2020, with retroactive effect of up to 30 months)."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Mietvertrag vom {{lease_date}} für die Wohnung {{property_address}} – Rüge wegen Verstoßes gegen die Mietpreisbremse

    Sehr geehrte Damen und Herren,

    die von uns vereinbarte und gezahlte Miete beträgt {{agreed_rent}}. Die ortsübliche Vergleichsmiete für unsere Wohnung beträgt nach dem Berliner Mietspiegel {{comparable_rent}}.

    Gemäß § 556d BGB ist die vereinbarte Miete insoweit nichtig, als sie die ortsübliche Miete um mehr als 10 Prozent übersteigt. Die zulässige Miete beläuft sich demnach auf {{permissible_rent}}.

    Wir rügen den Verstoß gegen die Mietpreisbremse hiermit ausdrücklich und bitten Sie um Bestätigung der korrigierten Miete bis zum {{response_deadline}}.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "rent_brake_violation_notice",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/mietpreisbremse-ruege-des-mieters-wegen-verstosses/",
    estimated_length: "150-200 words",
    legal_references: [ "§ 556d BGB", "§ 556e BGB", "§ 556f BGB", "§ 556g Abs. 2 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "lease_date", description: "Date the lease was signed", type: "date" },
      { variable: "agreed_rent", description: "Rent agreed and currently paid", type: "text" },
      { variable: "comparable_rent", description: "Local comparable rent according to the Mietspiegel", type: "text" },
      { variable: "permissible_rent", description: "Calculated permissible rent (comparable rent + 10%)", type: "text" },
      { variable: "response_deadline", description: "Deadline for the landlord to confirm the corrected rent", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 16: Schwerwiegende Wohnungsmängel – Schreiben an Bau- und Wohnungsaufsicht
Template.find_or_create_by!(name: "Schwerwiegende Wohnungsmängel – Schreiben an Bau- und Wohnungsaufsicht") do |template|
  template.description_de = "Schreiben an die Bau- und Wohnungsaufsicht des Bezirksamts zur Meldung schwerwiegender, vom Vermieter nicht behobener Wohnungsmängel."
  template.description_en = "Letter to the district building and housing authority reporting serious defects that the landlord has failed to remedy."
  template.instructions_de = "Nutzen Sie dieses Schreiben, wenn der Vermieter trotz vorheriger Mängelanzeige schwerwiegende Mängel nicht behebt. Fügen Sie eine Kopie Ihrer vorherigen Mängelanzeige an den Vermieter bei."
  template.instructions_en = "Use this letter when the landlord fails to remedy serious defects despite a prior defect notice. Attach a copy of your earlier defect notice to the landlord."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An das Bezirksamt {{district}}
    – Bau- und Wohnungsaufsicht –
    {{authority_address}}

    Betr.: Schwerwiegende Mängel in der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    wie Sie der beigefügten Kopie entnehmen können, wurde der Vermieter, {{recipient_name}}, {{recipient_address}}, bereits am {{previous_notice_date}} über das Vorliegen schwerwiegender Mängel unterrichtet:

    {{defect_description}}

    Da eine Behebung bislang nicht erfolgt ist, bitten wir um Prüfung des Sachverhalts und um Beteiligung an dem Verfahren gemäß § 13 Abs. 2 VwVfG.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "building_authority_complaint",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/schwerwiegende-wohnungsmaengel-schreiben-an-bau-und-wohnungsaufsicht/",
    estimated_length: "150-200 words",
    legal_references: [ "§ 13 Abs. 2 VwVfG" ],
    required_fields: [
      { variable: "district", description: "Berlin district responsible for the property", type: "text" },
      { variable: "authority_address", description: "Address of the district's Bau- und Wohnungsaufsicht office", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "previous_notice_date", description: "Date the landlord was first notified of the defects", type: "date" },
      { variable: "defect_description", description: "Description of the serious, unresolved defects", type: "long_text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 17: Untermiete – Bitte um Erlaubnis zur Untervermietung an aus der Ukraine Geflüchtete
Template.find_or_create_by!(name: "Untermiete – Bitte um Erlaubnis zur Untervermietung an aus der Ukraine Geflüchtete") do |template|
  template.description_de = "Bitte an den Vermieter um Erlaubnis, ein Zimmer der eigenen Wohnung an eine aus dem ukrainischen Kriegsgebiet geflüchtete Person untervermieten zu dürfen."
  template.description_en = "Request to the landlord for permission to sublet a room in the tenant's own apartment to a person who has fled the war in Ukraine."
  template.instructions_de = "Nennen Sie die vorgesehene Untermieterin/den vorgesehenen Untermieter mit Namen und bisheriger Anschrift, falls bekannt. Setzen Sie eine Frist für die Antwort des Vermieters."
  template.instructions_en = "Name the prospective subtenant and their previous address, if known. Set a deadline for the landlord's response."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Bitte um Erlaubnis zur Untervermietung eines Zimmers in der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    hiermit bitte ich um Genehmigung der Untervermietung eines Zimmers innerhalb meiner Wohnung. Ich möchte mit der Untervermietung {{subtenant_name}}, geflüchtet aus dem ukrainischen Kriegsgebiet, bislang wohnhaft in {{subtenant_previous_address}}, Unterstützung anbieten.

    Gern mache ich auf Wunsch weitere Angaben zur Person der/des Untermieterin/Untermieters.

    Ich bitte um Ihre schriftliche Antwort bis zum {{response_deadline}}.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "sublet_permission_request_ukraine_refugee",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/untermiete-bitte-um-erlaubnis-zur-untervermietung-an-aus-der-ukraine-gefluechtete/",
    estimated_length: "100-150 words",
    legal_references: [ "§ 553 Abs. 1 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "subtenant_name", description: "Name of the prospective subtenant", type: "text" },
      { variable: "subtenant_previous_address", description: "Previous address of the prospective subtenant, if known", type: "text" },
      { variable: "response_deadline", description: "Deadline for the landlord's written response", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 18: Untervermietung – Bitte um Erlaubnis
Template.find_or_create_by!(name: "Untervermietung – Bitte um Erlaubnis") do |template|
  template.description_de = "Bitte an den Vermieter um Erlaubnis zur Untervermietung eines Teils der Wohnung."
  template.description_en = "Request to the landlord for permission to sublet part of the apartment."
  template.instructions_de = "Nennen Sie die vorgesehene Untermieterin/den vorgesehenen Untermieter sowie den Grund für die geplante Untervermietung. Setzen Sie eine Frist für die Antwort des Vermieters."
  template.instructions_en = "Name the prospective subtenant and the reason for the planned subletting. Set a deadline for the landlord's response."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Bitte um Erlaubnis zur Untervermietung eines Teils der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    gemäß § 553 Abs. 1 BGB bitten wir Sie um die Erlaubnis, einen Teil der von uns gemieteten Wohnung untervermieten zu dürfen.

    Als Untermieter/in haben wir {{subtenant_name}} vorgesehen. {{subtenant_name}} wohnt derzeit in {{subtenant_previous_address}}. Falls gewünscht, machen wir zur Person des/der Untermieters/in gern weitere Angaben.

    Die Notwendigkeit der geplanten Untervermietung ergibt sich aus folgenden Gründen:

    {{subletting_reason}}

    Wir erwarten Ihre Antwort bis zum {{response_deadline}} und verbleiben

    mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "sublet_permission_request",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/untervermietung-bitte-um-erlaubnis/",
    estimated_length: "100-150 words",
    legal_references: [ "§ 553 Abs. 1 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "subtenant_name", description: "Name of the prospective subtenant", type: "text" },
      { variable: "subtenant_previous_address", description: "Current/previous address of the prospective subtenant", type: "text" },
      { variable: "subletting_reason", description: "Reason(s) the subletting is needed", type: "long_text" },
      { variable: "response_deadline", description: "Deadline for the landlord's written response", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 19: Untervermietung – Mustervertrag  [CONTENT APPROXIMATED - source page only offers a downloadable .docx, not extractable via fetch]
Template.find_or_create_by!(name: "Untervermietung – Mustervertrag") do |template|
  template.description_de = "Mustervertrag für die Untervermietung eines Zimmers oder Wohnungsteils an eine Untermieterin oder einen Untermieter."
  template.description_en = "Sample contract for subletting a room or part of an apartment to a subtenant."
  template.instructions_de = "Diese Vorlage ersetzt keine Rechtsberatung und muss an den Einzelfall angepasst werden. Schließen Sie den Untermietvertrag erst nach schriftlicher Erlaubnis des Vermieters zur Untervermietung ab."
  template.instructions_en = "This template does not replace legal advice and must be adapted to your specific case. Only sign the sublet contract after receiving the landlord's written permission to sublet."
  template.content = <<~LETTER
    Untermietvertrag

    zwischen {{tenant_names}}, {{property_address}} (nachfolgend „Hauptmieter")
    und {{subtenant_name}}, {{subtenant_previous_address}} (nachfolgend „Untermieter")

    1. Der Hauptmieter vermietet dem Untermieter ab dem {{sublet_start_date}} {{sublet_scope}} innerhalb der Wohnung {{property_address}} zur Nutzung.

    2. Die Untermiete beträgt {{sublet_rent}} monatlich, zahlbar im Voraus bis zum 3. Werktag eines Monats.

    3. Der Hauptmieter hat die schriftliche Erlaubnis des Vermieters zur Untervermietung vom {{landlord_permission_date}} erhalten.

    4. Das Untermietverhältnis kann von beiden Seiten mit einer Frist von {{notice_period}} gekündigt werden.

    5. Der Untermieter verpflichtet sich, die Hausordnung einzuhalten und die überlassenen Räume pflegsam zu behandeln.

    {{property_address}}, den {{date}}

    ______________________          ______________________
    Hauptmieter                      Untermieter
  LETTER
  template.metadata = {
    type: "sublet_contract_template",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/untervermietung-mustervertrag/",
    estimated_length: "150-200 words",
    legal_references: [],
    required_fields: [
      { variable: "tenant_names", description: "Name(s) of the main tenant(s)", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "subtenant_name", description: "Name of the subtenant", type: "text" },
      { variable: "subtenant_previous_address", description: "Previous address of the subtenant", type: "text" },
      { variable: "sublet_start_date", description: "Date the sublet arrangement begins", type: "date" },
      { variable: "sublet_scope", description: "Description of the room(s) or part of the apartment being sublet", type: "text" },
      { variable: "sublet_rent", description: "Monthly rent charged to the subtenant", type: "text" },
      { variable: "landlord_permission_date", description: "Date the landlord gave written permission to sublet", type: "date" },
      { variable: "notice_period", description: "Notice period for terminating the sublet", type: "text" },
      { variable: "date", description: "Date the sublet contract is signed", type: "date" }
    ]
  }
end
# Row 20: Wohnungsbesichtigung – Ausweichtermine
Template.find_or_create_by!(name: "Wohnungsbesichtigung – Ausweichtermine") do |template|
  template.description_de = "Angebot alternativer Termine an den Vermieter, wenn ein angekündigter Besichtigungstermin für die Wohnung ungelegen kommt."
  template.description_en = "Offer of alternative dates to the landlord when an announced apartment viewing appointment is inconvenient."
  template.instructions_de = "Nennen Sie mindestens zwei bis drei konkrete Ausweichtermine. Fordern Sie eine schriftliche Bestätigung mindestens 2 Tage vorher und begrenzen Sie die Anzahl der Besichtigungspersonen."
  template.instructions_en = "Offer at least two or three concrete alternative dates. Require written confirmation at least 2 days in advance and limit the number of visitors."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Wohnungsbesichtigung {{property_address}} – Ausweichtermine

    Sehr geehrte Damen und Herren,

    mit Schreiben vom {{announcement_date}} haben Sie eine Wohnungsbesichtigung mit {{visitor_description}} angekündigt. Leider sind wir am vorgeschlagenen Termin nicht zu Hause bzw. verhindert.

    Wir bieten Ihnen daher folgende Ausweichtermine an:

    {{alternative_dates}}

    Wir können die Termine nur einhalten, wenn sie mindestens 2 Tage zuvor von Ihnen schriftlich bestätigt werden. Bitte teilen Sie uns außerdem mit, welche Personen an der Besichtigung teilnehmen werden; dies sollten nicht mehr als 3 bis 4 Personen sein. Wir behalten uns vor, den Ausweis der Begleitpersonen einzusehen und uns deren Namen zu notieren.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "viewing_alternative_dates",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/wohnungsbesichtigung-ausweichtermine/",
    estimated_length: "100-150 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "announcement_date", description: "Date of the landlord's letter announcing the viewing", type: "date" },
      { variable: "visitor_description", description: "Who the landlord announced would attend (e.g. a prospective buyer)", type: "text" },
      { variable: "alternative_dates", description: "List of 2-3 proposed alternative dates and time windows", type: "long_text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 21: Wohnungsbesichtigung – Terminschwierigkeiten
Template.find_or_create_by!(name: "Wohnungsbesichtigung – Terminschwierigkeiten") do |template|
  template.description_de = "Vorschlag eines festen wöchentlichen Besichtigungstermins, wenn es wiederholt zu Terminschwierigkeiten mit dem Vermieter kommt."
  template.description_en = "Proposal of a fixed weekly viewing slot when scheduling apartment viewings with the landlord repeatedly causes difficulties."
  template.instructions_de = "Diese Vorlage eignet sich, wenn einzelne Ausweichtermine nicht ausreichen und eine dauerhafte Regelung sinnvoll ist. Begrenzen Sie die Anzahl der Besichtigungspersonen und fordern Sie eine Vorankündigung."
  template.instructions_en = "Use this template when single alternative dates are not enough and a standing arrangement makes more sense. Limit the number of visitors and require advance notice."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Wohnungsbesichtigung {{property_address}} – Terminschwierigkeiten

    Sehr geehrte Damen und Herren,

    wegen der Schwierigkeiten, Besichtigungstermine zu unterschiedlichen Zeiten zu vereinbaren, stellen Sie sich bitte auf folgendes Verfahren ein: Wir stehen künftig einmal wöchentlich, und zwar {{recurring_weekday}} von {{recurring_time_range}} Uhr, für Besichtigungen zur Verfügung.

    Besuche kündigen Sie uns bitte spätestens 3 Tage vorher schriftlich unter Nennung der Namen der Besucher an; andernfalls behalten wir uns vor, deren Ausweise einzusehen. Besichtigungen mit mehr als 3 bis 4 fremden Personen sind für uns unzumutbar und werden von uns nicht akzeptiert.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "viewing_recurring_schedule",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/wohnungsbesichtigung-terminschwierigkeiten/",
    estimated_length: "100-150 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "recurring_weekday", description: "Weekday proposed for the standing viewing slot", type: "text" },
      { variable: "recurring_time_range", description: "Time window proposed for the standing viewing slot", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 22: Wohnungsmängel – Aufrechnung der Kosten einer Ersatzvornahme
Template.find_or_create_by!(name: "Wohnungsmängel – Aufrechnung der Kosten einer Ersatzvornahme") do |template|
  template.description_de = "Mitteilung an den Vermieter, dass ein Mangel nach fruchtlosem Fristablauf selbst beseitigt wurde und die Kosten mit der Miete verrechnet werden."
  template.description_en = "Notice to the landlord that a defect was self-remedied after the repair deadline expired unused, and that the costs will be offset against rent."
  template.instructions_de = "Diese Vorlage setzt voraus, dass zuvor bereits eine Mängelanzeige mit Fristsetzung erfolgt ist und die Frist erfolglos verstrichen ist. Fügen Sie Kopien der Handwerkerrechnungen bei und kündigen Sie die Aufrechnung mit ausreichendem Vorlauf an."
  template.instructions_en = "This template assumes a prior defect notice with a repair deadline was sent and the deadline passed unused. Attach copies of the contractor invoices and announce the offset with sufficient advance notice."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Wohnungsmängel {{property_address}} – Aufrechnung der Kosten einer Ersatzvornahme

    Sehr geehrte Damen und Herren,

    nachdem Sie die mit Schreiben vom {{deadline_letter_date}} gesetzte Frist zur Beseitigung des angezeigten Mangels ({{defect_description}}) verstreichen ließen, ohne den Mangel zu beseitigen, haben wir selbst Handwerker mit der Mängelbeseitigung beauftragt.

    Für die Mängelbeseitigung haben wir einen Betrag von {{repair_cost}} EUR an die beauftragten Handwerker gezahlt. Kopien der entsprechenden Rechnungen fügen wir diesem Schreiben bei.

    Wir teilen Ihnen hiermit mit, dass wir diesen Betrag ab dem {{offset_start_date}} gegen die laufenden Mietzahlungen aufrechnen werden.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "defect_self_repair_offset",
    tone: "formal",
    language: "de",
    source: "Berliner Mieterverein",
    source_url: "https://www.berliner-mieterverein.de/musterschreiben/wohnungsmaengel-aufrechnung-der-kosten-einer-ersatzvornahme/",
    estimated_length: "100-180 words",
    legal_references: [ "§ 536a Abs. 2 BGB", "§ 556b Abs. 2 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "deadline_letter_date", description: "Date of the earlier letter that set the repair deadline", type: "date" },
      { variable: "defect_description", description: "Description of the defect that was self-remedied", type: "long_text" },
      { variable: "repair_cost", description: "Total amount paid to the contractor(s), in EUR", type: "text" },
      { variable: "offset_start_date", description: "Date from which the amount will be offset against rent", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 23: Betriebskosten: Belegeinsicht vor Ort
Template.find_or_create_by!(name: "Betriebskosten: Belegeinsicht vor Ort") do |template|
  template.description_de = "Bitte um Terminvereinbarung zur Einsichtnahme der Originalbelege einer Betriebskostenabrechnung vor Ort, bevor eine Zahlung geleistet wird."
  template.description_en = "Request to schedule an on-site appointment to inspect the original supporting documents of an operating cost statement, before making payment."
  template.instructions_de = "Nutzen Sie diese Vorlage, wenn Sie die Belege noch nicht geprüft haben und zunächst nur Einsicht nehmen möchten, bevor Sie einen konkreten Fehler beanstanden. Bieten Sie mehrere Termine an und setzen Sie eine Ersatzfrist."
  template.instructions_en = "Use this template when you have not yet reviewed the documents and simply want to inspect them first, before raising a specific objection. Offer several dates and set a fallback deadline."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Betriebskostenabrechnung {{statement_year}} für die Wohnung {{property_address}} – Belegeinsicht vor Ort

    Sehr geehrte Damen und Herren,

    die Betriebskostenabrechnung für {{statement_year}} habe ich erhalten.

    Bevor ich den geforderten Nachzahlungsbetrag leiste bzw. das Guthaben annehme, möchte ich die zugrunde liegenden Originalbelege (Rechnungen, Quittungen und Verträge) einsehen.

    Für die Einsichtnahme schlage ich folgende Termine vor:

    {{proposed_dates}}

    Bitte bestätigen Sie mir einen dieser Termine schriftlich, oder nennen Sie mir zwei alternative Termine innerhalb der üblichen Geschäftszeiten. Bitte teilen Sie mir außerdem mit, wo die Belegeinsicht stattfinden wird.

    Ich bitte um Rückmeldung bis zum {{response_deadline}}. Sollte ich bis dahin nichts von Ihnen hören oder kein Termin zustande kommen, werde ich mich am {{fallback_date}} persönlich in Ihren Geschäftsräumen ({{landlord_office_address}}) zur Einsichtnahme einfinden. Ich bitte Sie, die Unterlagen dann bereitzuhalten.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "utility_bill_document_inspection_onsite",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/betriebskosten-belegeinsicht-vor-ort",
    estimated_length: "150-220 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "statement_year", description: "Billing year of the operating cost statement", type: "text" },
      { variable: "proposed_dates", description: "List of proposed dates/time windows for the inspection", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should confirm a date", type: "date" },
      { variable: "fallback_date", description: "Date the tenant will show up in person if no appointment is confirmed", type: "date" },
      { variable: "landlord_office_address", description: "Address of the landlord's or manager's office", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 24: Betriebskosten: Belegzusendung
Template.find_or_create_by!(name: "Betriebskosten: Belegzusendung") do |template|
  template.description_de = "Bitte um Zusendung von Kopien der Belege einer Betriebskostenabrechnung, wenn eine Einsichtnahme vor Ort unzumutbar ist."
  template.description_en = "Request to receive copies of the supporting documents of an operating cost statement by mail, when an on-site inspection would be unreasonable."
  template.instructions_de = "Nutzen Sie diese Vorlage nur, wenn die Einsichtnahme in den Räumen des Vermieters für Sie tatsächlich unzumutbar ist (z. B. Krankheit, große Entfernung). Begründen Sie die Unzumutbarkeit konkret."
  template.instructions_en = "Use this template only when inspecting the documents at the landlord's premises would genuinely be unreasonable for you (e.g. illness, long distance). State the specific reason."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Betriebskostenabrechnung {{statement_year}} für die Wohnung {{property_address}} – Belegzusendung

    Sehr geehrte Damen und Herren,

    die Betriebskostenabrechnung für {{statement_year}} habe ich erhalten.

    Bevor ich den Nachzahlungsbetrag leiste bzw. das Guthaben annehme, möchte ich die entsprechenden Originalbelege überprüfen.

    Mieter/innen sind nicht zur Einsichtnahme der Belege in den Räumlichkeiten des Vermieters verpflichtet, wenn dies für sie unzumutbar ist; in diesem Fall steht ihnen ein Recht auf Belegzusendung zu. {{unreasonableness_reason}}

    Ich benötige Kopien der Belege für folgende Kostenpositionen:

    {{cost_items}}

    Ich bitte um zeitnahe Zusendung der Kopien bis zum {{response_deadline}} und erstatte die üblichen Kopierkosten.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "utility_bill_document_mail_request",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/betriebskosten-belegzusendung",
    estimated_length: "150-220 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "statement_year", description: "Billing year of the operating cost statement", type: "text" },
      { variable: "unreasonableness_reason", description: "Concrete reason why an on-site inspection is unreasonable (e.g. illness, distance)", type: "long_text" },
      { variable: "cost_items", description: "List of cost line items the tenant needs documents for", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the copies should be sent", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 25: Betriebskosten: Fehlerhafte Heizkostenabrechnung
Template.find_or_create_by!(name: "Betriebskosten: Fehlerhafte Heizkostenabrechnung") do |template|
  template.description_de = "Widerspruch gegen eine Heizkostenabrechnung, die gegen die Vorgaben der Heizkostenverordnung verstößt oder fehlerhaft/unvollständig ist."
  template.description_en = "Objection to a heating cost statement that violates the Heating Cost Ordinance or is otherwise incorrect or incomplete."
  template.instructions_de = "Listen Sie konkret auf, welche Vorgaben der HeizkostenV verletzt sind (z. B. fehlende Trennung von Heiz- und Warmwasserkosten, fehlender Verbrauchsanteil) oder welche Angaben fehlen. Setzen Sie eine angemessene Frist zur Korrektur."
  template.instructions_en = "List specifically which HeizkostenV requirements are violated (e.g. missing separation of heating and hot water costs, missing consumption share) or what information is missing. Set a reasonable deadline for correction."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Heizkostenabrechnung {{statement_year}} für die Wohnung {{property_address}} – Widerspruch wegen Fehlerhaftigkeit

    Sehr geehrte Damen und Herren,

    die Heizkostenabrechnung für {{statement_year}} habe ich erhalten. Die Abrechnung entspricht nicht den Vorgaben der Heizkostenverordnung (HeizkostenV) und ist aus folgenden Gründen fehlerhaft:

    {{billing_issues}}

    Ohne die fehlenden Angaben ist die Abrechnung für mich weder nachvollziehbar noch überprüfbar. Ich fordere Sie auf, mir bis zum {{response_deadline}} eine korrigierte und vollständige Abrechnung zu übersenden.

    Bis zur Vorlage einer ordnungsgemäßen Abrechnung behalte ich mir vor, die Zahlung des Nachzahlungsbetrages zurückzuhalten. Sollten die beanstandeten Mängel nicht fristgerecht korrigiert werden, mache ich von meinem Recht auf eine Kürzung meines Kostenanteils um 15 % gemäß § 12 HeizkostenV Gebrauch.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "heating_bill_dispute",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/detailansicht/article/betriebskosten-fehlerhafte-heizkostenabrechnung/",
    estimated_length: "180-260 words",
    legal_references: [ "§ 12 HeizkostenV" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "statement_year", description: "Billing year of the heating cost statement", type: "text" },
      { variable: "billing_issues", description: "Specific HeizkostenV violations or errors found in the statement", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which a corrected statement should be sent", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 26: Betriebskosten: Verspätete Betriebskostenabrechnung
Template.find_or_create_by!(name: "Betriebskosten: Verspätete Betriebskostenabrechnung") do |template|
  template.description_de = "Zurückweisung einer Nachzahlungsforderung aus einer Betriebskostenabrechnung, die nach Ablauf der gesetzlichen Zwölfmonatsfrist erstellt wurde."
  template.description_en = "Rejection of a payment demand from an operating cost statement that was issued after the statutory twelve-month deadline."
  template.instructions_de = "Diese Vorlage eignet sich nur, wenn der Vermieter die Verspätung selbst zu vertreten hat und keine Gründe für die Fristüberschreitung genannt wurden. Prüfen Sie das Zugangsdatum der Abrechnung genau."
  template.instructions_en = "This template applies only when the landlord is responsible for the delay and no reasons for missing the deadline were given. Check the exact date the statement was received."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Betriebskostenabrechnung für {{statement_year}} – Zurückweisung wegen Verspätung

    Sehr geehrte Damen und Herren,

    die von Ihnen erstellte Betriebskostenabrechnung für {{statement_year}} ist mir am {{receipt_date}} zugegangen. Mit dieser Abrechnung machen Sie eine Nachzahlung für den Zeitraum vom {{period_start}} bis {{period_end}} geltend.

    Gemäß § 556 Abs. 3 BGB ist über die Betriebskosten innerhalb von zwölf Monaten nach Ende des Abrechnungszeitraums abzurechnen. Wird diese Frist überschritten, können Nachforderungen nur dann noch geltend gemacht werden, wenn der Vermieter die Fristversäumnis nicht zu vertreten hat.

    Da Sie die Abrechnungsfrist nicht eingehalten und auch keine Umstände vorgetragen haben, weshalb Sie die Verspätung nicht zu vertreten hätten, ist die von Ihnen geltend gemachte Nachforderung gegenstandslos.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "utility_bill_late_statement_objection",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/betriebskosten-verspaetete-betriebskostenabrechnung",
    estimated_length: "120-180 words",
    legal_references: [ "§ 556 Abs. 3 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "statement_year", description: "Billing year of the operating cost statement", type: "text" },
      { variable: "receipt_date", description: "Date the tenant received the statement", type: "date" },
      { variable: "period_start", description: "Start date of the billing period", type: "date" },
      { variable: "period_end", description: "End date of the billing period", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end
# Row 27: Mängel: Ersatzvornahme
Template.find_or_create_by!(name: "Mängel: Ersatzvornahme") do |template|
  template.description_de = "Forderung der Erstattung von Kosten, die durch eine vom Mieter selbst veranlasste Mängelbeseitigung (Ersatzvornahme) entstanden sind, nachdem der Vermieter eine gesetzte Frist verstreichen ließ."
  template.description_en = "Demand for reimbursement of costs incurred when the tenant had a defect repaired themselves (self-help remedy) after the landlord let a set deadline pass."
  template.instructions_de = "Setzen Sie diesen Musterbrief erst ein, nachdem Sie dem Vermieter zuvor bereits eine Mängelanzeige mit Fristsetzung geschickt haben und diese Frist erfolglos verstrichen ist. Fügen Sie die Handwerkerrechnung in Kopie bei."
  template.instructions_en = "Use this template only after you have already sent the landlord a defect notice with a deadline, and that deadline has passed without repair. Enclose a copy of the repair invoice."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Ersatzvornahme für die Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    nachdem Sie die Ihnen mit meinem Schreiben vom {{previous_letter_date}} gesetzte Frist haben verstreichen lassen, ohne die mitgeteilten Mängel zu beseitigen, habe ich nunmehr die Mängelbeseitigung veranlasst und Handwerker mit der Ausführung der erforderlichen Arbeiten beauftragt.

    Mir sind hierfür Aufwendungen in Höhe von {{repair_costs}} Euro entstanden (Rechnung in Kopie beigefügt).

    Ich bitte um Überweisung des Betrags auf mein Konto {{bank_details}}. Hierzu setze ich Ihnen eine Frist bis zum {{payment_deadline}}.

    Für den Fall der Nichtzahlung kündige ich an, dass ich die mir entstandenen Kosten mit der Miete für {{offset_month}} aufrechnen werde.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "ersatzvornahme_cost_claim",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/maengel-ersatzvornahme",
    estimated_length: "100-150 words",
    legal_references: [ "§ 536a BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "previous_letter_date", description: "Date of the earlier defect notice that set the repair deadline", type: "date" },
      { variable: "repair_costs", description: "Amount paid for the self-arranged repair, in euros", type: "text" },
      { variable: "bank_details", description: "Tenant's bank account details for reimbursement", type: "text" },
      { variable: "payment_deadline", description: "Deadline by which the landlord should reimburse the costs", type: "date" },
      { variable: "offset_month", description: "The month whose rent the tenant will offset the costs against if unpaid", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 28: Mietsicherheit: Rückzahlung einer überhöhten Kaution
Template.find_or_create_by!(name: "Mietsicherheit: Rückzahlung einer überhöhten Kaution") do |template|
  template.description_de = "Aufforderung an den Vermieter, den Teil der Kaution zurückzuzahlen, der die gesetzliche Höchstgrenze von drei Monatsnettomieten übersteigt."
  template.description_en = "Request that the landlord refund the portion of a security deposit that exceeds the statutory cap of three months' net rent."
  template.instructions_de = "Prüfen Sie zunächst, ob die vereinbarte und gezahlte Kaution tatsächlich mehr als das Dreifache Ihrer monatlichen Nettokaltmiete beträgt, bevor Sie dieses Schreiben versenden."
  template.instructions_en = "Before sending this letter, check that the deposit actually agreed and paid exceeds three times your monthly net (cold) rent."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Vereinbarung über Mietsicherheit für die Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    in dem zwischen uns geschlossenen Mietvertrag vom {{lease_date}} haben wir vereinbart, dass ich eine Mietsicherheit in Höhe von {{deposit_paid}} Euro an Sie leiste. Ich habe diesen Betrag bereits in voller Höhe an Sie überwiesen.

    Allerdings habe ich mittlerweile erfahren, dass eine Mietsicherheit höchstens das Dreifache einer Monatsnettomiete betragen darf. Bei einer monatlichen Nettokaltmiete von {{monthly_net_rent}} Euro darf sich meine Kaution folglich höchstens auf {{max_deposit}} Euro belaufen.

    Demnach habe ich {{overpaid_amount}} Euro zu viel an Sie gezahlt. Ich bitte Sie, diesen Betrag auf mein Konto {{bank_details}} zu überweisen. Hierzu setze ich Ihnen eine Frist bis zum {{payment_deadline}}.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "deposit_cap_violation",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/mietsicherheit-rueckzahlung-einer-ueberhoehten-kaution",
    estimated_length: "120-180 words",
    legal_references: [ "§ 551 Abs. 1 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "lease_date", description: "Date the lease was signed", type: "date" },
      { variable: "deposit_paid", description: "Total deposit amount already paid, in euros", type: "text" },
      { variable: "monthly_net_rent", description: "Monthly net (cold) rent, in euros", type: "text" },
      { variable: "max_deposit", description: "Legal maximum deposit (3x monthly net rent), in euros", type: "text" },
      { variable: "overpaid_amount", description: "Amount paid in excess of the legal maximum, in euros", type: "text" },
      { variable: "bank_details", description: "Tenant's bank account details for the refund", type: "text" },
      { variable: "payment_deadline", description: "Deadline by which the landlord should refund the excess", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 29: Modernisierung: Härteeinwand gesundheitliche Gründe
Template.find_or_create_by!(name: "Modernisierung: Härteeinwand gesundheitliche Gründe") do |template|
  template.description_de = "Widerspruch gegen eine angekündigte Modernisierungsmaßnahme mit der Begründung, dass die Baumaßnahmen aus gesundheitlichen Gründen eine unzumutbare Härte darstellen."
  template.description_en = "Objection to an announced modernization measure on the grounds that it would constitute an unreasonable hardship for health reasons."
  template.instructions_de = "Reichen Sie diesen Härteeinwand innerhalb der gesetzlichen Frist ein (in der Regel bis zum Ende des Monats, der auf den Zugang der Modernisierungsankündigung folgt). Legen Sie Ihre gesundheitliche Beeinträchtigung so konkret wie möglich dar; ärztliche Atteste können nachgereicht werden."
  template.instructions_en = "Submit this hardship objection within the statutory deadline (generally by the end of the month following receipt of the modernization notice). Describe your health condition as specifically as possible; medical certificates can be provided afterward."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Modernisierungsankündigung für die Wohnung {{property_address}} – Härteeinwand

    Sehr geehrte Damen und Herren,

    ich nehme Bezug auf Ihre Modernisierungsankündigung vom {{announcement_date}}.

    Hierzu teile ich Ihnen innerhalb der gesetzlichen Frist mit, dass die von Ihnen geplanten Baumaßnahmen für mich zu einer nicht zu rechtfertigenden Härte führen werden.

    Ich leide an {{health_condition}}. Dies führt dazu, dass ich dauerhaft auf {{health_requirement}} angewiesen bin, da anderenfalls eine Verschlechterung meiner gesundheitlichen Situation droht. Entsprechende ärztliche Atteste kann ich bei Bedarf nachreichen.

    Ersatzwohnraum, auf den ich zurückgreifen könnte, steht mir nicht zur Verfügung. Die angekündigten Maßnahmen stellen daher eine nicht zu rechtfertigende Härte für mich dar. Eine Duldung der Maßnahmen kommt bis zu einer Klärung dieser Punkte nicht in Betracht.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "modernization_hardship_health",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/modernisierung-haerteeinwand-gesundheitliche-gruende",
    estimated_length: "130-200 words",
    legal_references: [ "§ 555d Abs. 2 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "announcement_date", description: "Date of the landlord's modernization announcement", type: "date" },
      { variable: "health_condition", description: "Description of the tenant's health condition", type: "long_text" },
      { variable: "health_requirement", description: "What the tenant depends on due to their health condition (e.g. working water/heating, dust-free environment, quiet)", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 30: Modernisierung: Härteeinwand allgemeine Gründe
Template.find_or_create_by!(name: "Modernisierung: Härteeinwand allgemeine Gründe") do |template|
  template.description_de = "Widerspruch gegen eine angekündigte Modernisierungsmaßnahme mit der Begründung, dass die konkrete Art, der Zeitpunkt oder die Folgen der Bauausführung eine unzumutbare Härte darstellen."
  template.description_en = "Objection to an announced modernization measure on general grounds — arguing that the specific execution, timing, or consequences of the works amount to an unreasonable hardship."
  template.instructions_de = "Reichen Sie diesen Härteeinwand innerhalb der gesetzlichen Frist ein. Beschreiben Sie so konkret wie möglich, welche angekündigten Maßnahmen betroffen sind und welche Folgen sich daraus für Sie ergeben."
  template.instructions_en = "Submit this hardship objection within the statutory deadline. Describe as specifically as possible which announced measures are affected and what consequences they would have for you."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Modernisierungsankündigung für die Wohnung {{property_address}} – Härteeinwand

    Sehr geehrte Damen und Herren,

    ich nehme Bezug auf Ihre Modernisierungsankündigung vom {{announcement_date}}.

    Hierzu teile ich Ihnen innerhalb der gesetzlichen Frist mit, dass die von Ihnen geplanten Baumaßnahmen für mich zu einer nicht zu rechtfertigenden Härte führen werden. Ausweislich Ihrer Ankündigung sollen im und am Mietobjekt folgende Baumaßnahmen durchgeführt werden:

    {{planned_measures}}

    Dies führt zu folgenden Folgen, aus denen sich die Härte für mich ergibt:

    {{hardship_consequences}}

    Die Maßnahmen stellen sich daher für mich als eine nicht zu rechtfertigende Härte dar. Die geplanten Maßnahmen kann ich somit bis zu einer Klärung der vorgenannten Punkte nicht dulden.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "modernization_hardship_general",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/modernisierung-haerteeinwand-allgemeine-gruende",
    estimated_length: "130-200 words",
    legal_references: [ "§ 555d Abs. 2 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "announcement_date", description: "Date of the landlord's modernization announcement", type: "date" },
      { variable: "planned_measures", description: "The specific construction measures announced by the landlord that cause hardship", type: "long_text" },
      { variable: "hardship_consequences", description: "The specific consequences of those measures that create the hardship", type: "long_text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 31: Modernisierung: Härteeinwand finanzielle Gründe
Template.find_or_create_by!(name: "Modernisierung: Härteeinwand finanzielle Gründe") do |template|
  template.description_de = "Widerspruch gegen eine angekündigte Modernisierungsmaßnahme mit der Begründung, dass die zu erwartende Mieterhöhung für den Mieter wirtschaftlich nicht zumutbar ist."
  template.description_en = "Objection to an announced modernization measure on the grounds that the resulting rent increase would be financially unreasonable for the tenant."
  template.instructions_de = "Reichen Sie diesen Härteeinwand innerhalb der gesetzlichen Frist ein. Legen Sie die zu erwartende neue Gesamtmiete und Ihr Haushaltseinkommen möglichst konkret dar."
  template.instructions_en = "Submit this hardship objection within the statutory deadline. State the expected new total rent and your household income as concretely as possible."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Modernisierungsankündigung für die Wohnung {{property_address}} – Härteeinwand

    Sehr geehrte Damen und Herren,

    ich nehme Bezug auf Ihre Modernisierungsankündigung vom {{announcement_date}}.

    Hierzu teile ich Ihnen innerhalb der gesetzlichen Frist mit, dass die von Ihnen geplanten Baumaßnahmen nach deren Abschluss bei mir zu einer finanziellen Härte führen werden.

    Aus Ihrer Ankündigung ergibt sich, dass die Gesamtmiete zukünftig voraussichtlich {{new_total_rent}} Euro betragen wird. Mein monatliches Haushaltseinkommen liegt derzeit bei {{household_income}} Euro. Die Miete würde demnach mehr als {{income_percentage}} % meines Einkommens betragen, was mir wirtschaftlich nicht zumutbar ist.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "modernization_hardship_financial",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/modernisierung-haerteeinwand-finanzielle-gruende",
    estimated_length: "100-150 words",
    legal_references: [ "§ 555d Abs. 2 BGB" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "announcement_date", description: "Date of the landlord's modernization announcement", type: "date" },
      { variable: "new_total_rent", description: "Expected total rent after modernization, in euros", type: "text" },
      { variable: "household_income", description: "Tenant's monthly household income, in euros", type: "text" },
      { variable: "income_percentage", description: "Percentage of household income the new rent would represent", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 32: Tierhaltung
Template.find_or_create_by!(name: "Tierhaltung") do |template|
  template.description_de = "Bitte an den Vermieter um Erlaubnis zur Haltung eines Haustiers, sofern der Mietvertrag eine solche Erlaubnis voraussetzt."
  template.description_en = "Request to the landlord for permission to keep a pet, where the lease requires such consent."
  template.instructions_de = "Prüfen Sie zunächst Ihren Mietvertrag: Ist die Tierhaltung generell untersagt oder von der Zustimmung des Vermieters abhängig? Führen Sie ggf. bereits erteilte Erlaubnisse für andere Mieter im Haus als zusätzliches Argument an."
  template.instructions_en = "First check your lease: is pet ownership generally prohibited, or does it require the landlord's consent? If applicable, mention permissions already granted to other tenants in the building as extra support."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Tierhaltung in der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    hiermit möchte ich Sie um die Erlaubnis bitten, einen/eine {{animal_type}} zu halten, wofür laut unserem Mietvertrag Ihre Zustimmung erforderlich ist.

    Meine Wohnung ist mit {{apartment_size}} m² ausreichend groß, damit das Tier artgerecht leben kann. Zudem stehe ich dafür ein, dass es durch das Tier nicht zu Störungen der Hausordnung kommen wird.

    {{additional_reasons}}

    Ich bitte um Ihre Rückmeldung bis zum {{response_deadline}}.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "pet_permission_request",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/tierhaltung",
    estimated_length: "100-150 words",
    legal_references: [],
    required_fields: [
      { variable: "recipient_name", description: "Name of the landlord or property manager", type: "text" },
      { variable: "recipient_address", description: "Address of the landlord or property manager", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "animal_type", description: "Type of animal the tenant wants to keep", type: "text" },
      { variable: "apartment_size", description: "Size of the apartment in square meters", type: "text" },
      { variable: "additional_reasons", description: "Optional extra arguments, e.g. that neighbors already have similar pets", type: "long_text" },
      { variable: "response_deadline", description: "Deadline by which the landlord should respond", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end

# Row 33: Wohnungsübergabeprotokoll
# NOTE: not a letter but a checklist/protocol document - content and metadata.tone shaped accordingly (see report).
Template.find_or_create_by!(name: "Wohnungsübergabeprotokoll") do |template|
  template.description_de = "Protokoll zur Dokumentation des Zustands der Wohnung bei Ein- oder Auszug, inklusive Zählerständen, Mängeln und Schlüsselübergabe."
  template.description_en = "Protocol documenting the condition of the apartment at move-in or move-out, including meter readings, defects, and key handover."
  template.instructions_de = "Füllen Sie dieses Protokoll gemeinsam mit dem Vermieter oder der Hausverwaltung bei der Wohnungsübergabe aus und lassen Sie es von allen Anwesenden unterschreiben. Ziehen Sie idealerweise eine weitere Person als Zeugen hinzu."
  template.instructions_en = "Fill out this protocol together with the landlord or property manager at the handover appointment and have everyone present sign it. Ideally bring an additional person as a witness."
  template.content = <<~LETTER
    WOHNUNGSÜBERGABEPROTOKOLL

    Wohnung: {{property_address}}
    Übergabedatum: {{handover_date}}
    Art der Übergabe: {{handover_type}}

    Anwesende Personen:
    Mieter/in: {{tenant_names}}
    Vermieter/in bzw. Vertretung: {{landlord_name}}
    Zeuge/Zeugin: {{witness_name}}

    Zählerstände:
    Strom: {{electricity_reading}}
    Wasser: {{water_reading}}
    Gas: {{gas_reading}}
    Heizung: {{heating_reading}}

    Zustand der Räume (Mängel, Abnutzung, letzte Renovierung):
    {{room_condition_notes}}

    Schlüsselübergabe:
    Anzahl übergebener Schlüssel: {{keys_handed_over}}

    Sonstige Anmerkungen:
    {{additional_notes}}

    Unterschriften:
    Mieter/in: _______________________
    Vermieter/in: _______________________
    Zeuge/Zeugin: _______________________
  LETTER
  template.metadata = {
    type: "apartment_handover_protocol",
    tone: "neutral",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/wohnungsuebergabeprotokoll",
    estimated_length: "form document (not word-length letter)",
    legal_references: [],
    required_fields: [
      { variable: "property_address", description: "Address of the apartment", type: "text" },
      { variable: "handover_date", description: "Date of the handover appointment", type: "date" },
      { variable: "handover_type", description: "Move-in or move-out", type: "text" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) present", type: "text" },
      { variable: "landlord_name", description: "Name of the landlord or their representative present", type: "text" },
      { variable: "witness_name", description: "Name of the witness present, if any", type: "text" },
      { variable: "electricity_reading", description: "Electricity meter reading", type: "text" },
      { variable: "water_reading", description: "Water meter reading", type: "text" },
      { variable: "gas_reading", description: "Gas meter reading", type: "text" },
      { variable: "heating_reading", description: "Heating meter reading", type: "text" },
      { variable: "room_condition_notes", description: "Notes on the condition, defects, and last renovation of each room", type: "long_text" },
      { variable: "keys_handed_over", description: "Number and type of keys handed over", type: "text" },
      { variable: "additional_notes", description: "Any other remarks", type: "long_text" }
    ]
  }
end

# Row 34: Wohnungsvermittlung: Rückzahlung eines Teils der Provision
Template.find_or_create_by!(name: "Wohnungsvermittlung: Rückzahlung eines Teils der Provision") do |template|
  template.description_de = "Forderung der Rückzahlung des Teils der Maklerprovision, der die gesetzliche Höchstgrenze von zwei Monatsmieten zuzüglich Umsatzsteuer übersteigt."
  template.description_en = "Demand for repayment of the portion of a residential letting agent's commission that exceeds the statutory cap of two months' rent plus VAT."
  template.instructions_de = "Prüfen Sie anhand Ihres Vermittlungsvertrags und der vereinbarten Miete, ob die tatsächlich gezahlte Provision mehr als zwei Monatsmieten zuzüglich 19 % Umsatzsteuer betrug, bevor Sie dieses Schreiben versenden."
  template.instructions_en = "Before sending, check against your brokerage contract and rent whether the commission actually paid exceeded two months' rent plus 19% VAT."
  template.content = <<~LETTER
    Berlin, den {{date}}

    An {{recipient_name}}
    {{recipient_address}}

    Betr.: Provision für die Vermittlung der Wohnung {{property_address}}

    Sehr geehrte Damen und Herren,

    wir haben am {{brokerage_contract_date}} einen Vertrag über die Vermittlung der Wohnung {{property_address}} abgeschlossen. Dabei haben wir vereinbart, dass ich bei erfolgreicher Vermittlung insgesamt 3 Monatsmieten zuzüglich Umsatzsteuer an Sie entrichte. Folglich habe ich am {{payment_date}} einen Betrag in Höhe von {{amount_paid}} Euro an Sie überwiesen.

    In der Zwischenzeit habe ich jedoch in Erfahrung gebracht, dass eine Maklerprovision für die Vermittlung von Wohnraum höchstens 2 Monatsmieten zuzüglich Umsatzsteuer betragen darf. In meinem Fall betragen 2 Monatsmieten {{two_months_rent}} Euro, 19 % Umsatzsteuer davon ergeben {{vat_amount}} Euro. Ich hätte demnach höchstens {{max_commission}} Euro an Provision zahlen müssen. Ich habe folglich {{overpaid_amount}} Euro zu viel bezahlt.

    Ich bitte Sie, diesen Betrag auf mein Konto {{bank_details}} zu überweisen. Hierzu setze ich Ihnen eine Frist bis zum {{payment_deadline}}.

    Nach erfolglosem Fristablauf werde ich meinen Anspruch gegen Sie gerichtlich durchsetzen.

    Mit freundlichen Grüßen
    {{tenant_names}}
  LETTER
  template.metadata = {
    type: "broker_fee_partial_refund",
    tone: "formal",
    language: "de",
    source: "Berliner MieterGemeinschaft",
    source_url: "https://www.bmgev.de/mietrecht/musterbriefe/wohnungsvermittlung-rueckzahlung-eines-teils-der-provision",
    estimated_length: "150-200 words",
    legal_references: [ "§ 3 WoVermittG" ],
    required_fields: [
      { variable: "recipient_name", description: "Name of the letting agent", type: "text" },
      { variable: "recipient_address", description: "Address of the letting agent", type: "text" },
      { variable: "property_address", description: "Address of the rented apartment", type: "text" },
      { variable: "brokerage_contract_date", description: "Date the brokerage contract was signed", type: "date" },
      { variable: "payment_date", description: "Date the commission was paid", type: "date" },
      { variable: "amount_paid", description: "Total commission amount paid, in euros", type: "text" },
      { variable: "two_months_rent", description: "Two months' rent, in euros", type: "text" },
      { variable: "vat_amount", description: "19% VAT on two months' rent, in euros", type: "text" },
      { variable: "max_commission", description: "Legal maximum commission (2 months' rent + VAT), in euros", type: "text" },
      { variable: "overpaid_amount", description: "Amount paid in excess of the legal maximum, in euros", type: "text" },
      { variable: "bank_details", description: "Tenant's bank account details for the refund", type: "text" },
      { variable: "payment_deadline", description: "Deadline by which the agent should refund the excess", type: "date" },
      { variable: "tenant_names", description: "Name(s) of the tenant(s) signing the letter", type: "text" }
    ]
  }
end


puts "➔ #{Template.count} letter templates created\n\n"
puts "-------------------------"
puts "-------------------------"
puts "-------------------------"
puts "-------------------------"
puts "To see things in the seed, that is genius 🌱 — Lao Tzu"
