########### DESTRUCTION ###########

puts "Clearing existing data... 🧹"

puts "-------------------------"
puts "-------------------------"

Entry.destroy_all
Letter.destroy_all
Claim.destroy_all
Contact.destroy_all
Tenant.destroy_all
Property.destroy_all
User.destroy_all
Template.destroy_all
LawText.destroy_all

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
  tenant.status = "added"
end

Tenant.find_or_create_by!(user: sub_tenant_user, property: property) do |tenant|
  tenant.role = "sub_tenant"
  tenant.status = "added"
end

Tenant.find_or_create_by!(user: co_tenant_user, property: property) do |tenant|
  tenant.role = "co_tenant"
  tenant.status = "added"
end

Tenant.find_or_create_by!(user: life_partner_user, property: property) do |tenant|
  tenant.role = "life_partner"
  tenant.status = "added"
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


##### LAW TEXTS #####

puts "8 - Creating law texts..."
puts "-------------------------"

law_texts_data = [
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 535 Inhalt und Hauptpflichten des Mietvertrags',
    content: <<~LAW_TEXT
      (1) Durch den Mietvertrag wird der Vermieter verpflichtet, dem Mieter den Gebrauch der Mietsache während der Mietzeit zu gewähren. Der Vermieter hat die Mietsache dem Mieter in einem zum vertragsgemäßen Gebrauch geeigneten Zustand zu überlassen und sie während der Mietzeit in diesem Zustand zu erhalten. Er hat die auf der Mietsache ruhenden Lasten zu tragen.
      (2) Der Mieter ist verpflichtet, dem Vermieter die vereinbarte Miete zu entrichten.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 536 Mietminderung bei Sach- und Rechtsmängeln',
    content: <<~LAW_TEXT
      (1) Hat die Mietsache zur Zeit der Überlassung an den Mieter einen Mangel, der ihre Tauglichkeit zum vertragsgemäßen Gebrauch aufhebt, oder entsteht während der Mietzeit ein solcher Mangel, so ist der Mieter für die Zeit, in der die Tauglichkeit aufgehoben ist, von der Entrichtung der Miete befreit. Für die Zeit, während der die Tauglichkeit gemindert ist, hat er nur eine angemessen herabgesetzte Miete zu entrichten. Eine unerhebliche Minderung der Tauglichkeit bleibt außer Betracht.
      (1a) Für die Dauer von drei Monaten bleibt eine Minderung der Tauglichkeit außer Betracht, soweit diese auf Grund einer Maßnahme eintritt, die einer energetischen Modernisierung nach § 555b Nummer 1 dient.
      (2) Absatz 1 Satz 1 und 2 gilt auch, wenn eine zugesicherte Eigenschaft fehlt oder später wegfällt.
      (3) Wird dem Mieter der vertragsgemäße Gebrauch der Mietsache durch das Recht eines Dritten ganz oder zum Teil entzogen, so gelten die Absätze 1 und 2 entsprechend.
      (4) Bei einem Mietverhältnis über Wohnraum ist eine zum Nachteil des Mieters abweichende Vereinbarung unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 536a Schadens- und Aufwendungsersatzanspruch des Mieters wegen eines Mangels',
    content: <<~LAW_TEXT
      (1) Ist ein Mangel im Sinne des § 536 bei Vertragsschluss vorhanden oder entsteht ein solcher Mangel später wegen eines Umstands, den der Vermieter zu vertreten hat, oder kommt der Vermieter mit der Beseitigung eines Mangels in Verzug, so kann der Mieter unbeschadet der Rechte aus § 536 Schadensersatz verlangen.
      (2) Der Mieter kann den Mangel selbst beseitigen und Ersatz der erforderlichen Aufwendungen verlangen, wenn
      1. der Vermieter mit der Beseitigung des Mangels in Verzug ist oder
      2. die umgehende Beseitigung des Mangels zur Erhaltung oder Wiederherstellung des Bestands der Mietsache notwendig ist.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 536b Kenntnis des Mieters vom Mangel bei Vertragsschluss oder Annahme',
    content: <<~LAW_TEXT
      Kennt der Mieter bei Vertragsschluss den Mangel der Mietsache, so stehen ihm die Rechte aus den §§ 536 und 536a nicht zu. Ist ihm der Mangel infolge grober Fahrlässigkeit unbekannt geblieben, so stehen ihm diese Rechte nur zu, wenn der Vermieter den Mangel arglistig verschwiegen hat. Nimmt der Mieter eine mangelhafte Sache an, obwohl er den Mangel kennt, so kann er die Rechte aus den §§ 536 und 536a nur geltend machen, wenn er sich seine Rechte bei der Annahme vorbehält.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 536c Während der Mietzeit auftretende Mängel; Mängelanzeige durch den Mieter',
    content: <<~LAW_TEXT
      (1) Zeigt sich im Laufe der Mietzeit ein Mangel der Mietsache oder wird eine Maßnahme zum Schutz der Mietsache gegen eine nicht vorhergesehene Gefahr erforderlich, so hat der Mieter dies dem Vermieter unverzüglich anzuzeigen. Das Gleiche gilt, wenn ein Dritter sich ein Recht an der Sache anmaßt.
      (2) Unterlässt der Mieter die Anzeige, so ist er dem Vermieter zum Ersatz des daraus entstehenden Schadens verpflichtet. Soweit der Vermieter infolge der Unterlassung der Anzeige nicht Abhilfe schaffen konnte, ist der Mieter nicht berechtigt,
      1. die in § 536 bestimmten Rechte geltend zu machen,
      2. nach § 536a Abs. 1 Schadensersatz zu verlangen oder
      3. ohne Bestimmung einer angemessenen Frist zur Abhilfe nach § 543 Abs. 3 Satz 1 zu kündigen.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 536d Vertraglicher Ausschluss von Rechten des Mieters wegen eines Mangels',
    content: <<~LAW_TEXT
      Auf eine Vereinbarung, durch die die Rechte des Mieters wegen eines Mangels der Mietsache ausgeschlossen oder beschränkt werden, kann sich der Vermieter nicht berufen, wenn er den Mangel arglistig verschwiegen hat.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 537 Entrichtung der Miete bei persönlicher Verhinderung des Mieters',
    content: <<~LAW_TEXT
      (1) Der Mieter wird von der Entrichtung der Miete nicht dadurch befreit, dass er durch einen in seiner Person liegenden Grund an der Ausübung seines Gebrauchsrechts gehindert wird. Der Vermieter muss sich jedoch den Wert der ersparten Aufwendungen sowie derjenigen Vorteile anrechnen lassen, die er aus einer anderweitigen Verwertung des Gebrauchs erlangt.
      (2) Solange der Vermieter infolge der Überlassung des Gebrauchs an einen Dritten außerstande ist, dem Mieter den Gebrauch zu gewähren, ist der Mieter zur Entrichtung der Miete nicht verpflichtet.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 538 Abnutzung der Mietsache durch vertragsgemäßen Gebrauch',
    content: <<~LAW_TEXT
      Veränderungen oder Verschlechterungen der Mietsache, die durch den vertragsgemäßen Gebrauch herbeigeführt werden, hat der Mieter nicht zu vertreten.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 539 Ersatz sonstiger Aufwendungen und Wegnahmerecht des Mieters',
    content: <<~LAW_TEXT
      (1) Der Mieter kann vom Vermieter Aufwendungen auf die Mietsache, die der Vermieter ihm nicht nach § 536a Abs. 2 zu ersetzen hat, nach den Vorschriften über die Geschäftsführung ohne Auftrag ersetzt verlangen.
      (2) Der Mieter ist berechtigt, eine Einrichtung wegzunehmen, mit der er die Mietsache versehen hat.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 540 Gebrauchsüberlassung an Dritte',
    content: <<~LAW_TEXT
      (1) Der Mieter ist ohne die Erlaubnis des Vermieters nicht berechtigt, den Gebrauch der Mietsache einem Dritten zu überlassen, insbesondere sie weiter zu vermieten. Verweigert der Vermieter die Erlaubnis, so kann der Mieter das Mietverhältnis außerordentlich mit der gesetzlichen Frist kündigen, sofern nicht in der Person des Dritten ein wichtiger Grund vorliegt.
      (2) Überlässt der Mieter den Gebrauch einem Dritten, so hat er ein dem Dritten bei dem Gebrauch zur Last fallendes Verschulden zu vertreten, auch wenn der Vermieter die Erlaubnis zur Überlassung erteilt hat.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 541 Unterlassungsklage bei vertragswidrigem Gebrauch',
    content: <<~LAW_TEXT
      Setzt der Mieter einen vertragswidrigen Gebrauch der Mietsache trotz einer Abmahnung des Vermieters fort, so kann dieser auf Unterlassung klagen.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 542 Ende des Mietverhältnisses',
    content: <<~LAW_TEXT
      (1) Ist die Mietzeit nicht bestimmt, so kann jede Vertragspartei das Mietverhältnis nach den gesetzlichen Vorschriften kündigen.
      (2) Ein Mietverhältnis, das auf bestimmte Zeit eingegangen ist, endet mit dem Ablauf dieser Zeit, sofern es nicht
      1. in den gesetzlich zugelassenen Fällen außerordentlich gekündigt oder
      2. verlängert wird.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 543 Außerordentliche fristlose Kündigung aus wichtigem Grund',
    content: <<~LAW_TEXT
      (1) Jede Vertragspartei kann das Mietverhältnis aus wichtigem Grund außerordentlich fristlos kündigen. Ein wichtiger Grund liegt vor, wenn dem Kündigenden unter Berücksichtigung aller Umstände des Einzelfalls, insbesondere eines Verschuldens der Vertragsparteien, und unter Abwägung der beiderseitigen Interessen die Fortsetzung des Mietverhältnisses bis zum Ablauf der Kündigungsfrist oder bis zur sonstigen Beendigung des Mietverhältnisses nicht zugemutet werden kann.
      (2) Ein wichtiger Grund liegt insbesondere vor, wenn
      1. dem Mieter der vertragsgemäße Gebrauch der Mietsache ganz oder zum Teil nicht rechtzeitig gewährt oder wieder entzogen wird,
      2. der Mieter die Rechte des Vermieters dadurch in erheblichem Maße verletzt, dass er die Mietsache durch Vernachlässigung der ihm obliegenden Sorgfalt erheblich gefährdet oder sie unbefugt einem Dritten überlässt oder
      3. der Mieter
      a) für zwei aufeinander folgende Termine mit der Entrichtung der Miete oder eines nicht unerheblichen Teils der Miete in Verzug ist oder
      b) in einem Zeitraum, der sich über mehr als zwei Termine erstreckt, mit der Entrichtung der Miete in Höhe eines Betrages in Verzug ist, der die Miete für zwei Monate erreicht.
      Im Falle des Satzes 1 Nr. 3 ist die Kündigung ausgeschlossen, wenn der Vermieter vorher befriedigt wird. Sie wird unwirksam, wenn sich der Mieter von seiner Schuld durch Aufrechnung befreien konnte und unverzüglich nach der Kündigung die Aufrechnung erklärt.
      (3) Besteht der wichtige Grund in der Verletzung einer Pflicht aus dem Mietvertrag, so ist die Kündigung erst nach erfolglosem Ablauf einer zur Abhilfe bestimmten angemessenen Frist oder nach erfolgloser Abmahnung zulässig. Dies gilt nicht, wenn
      1. eine Frist oder Abmahnung offensichtlich keinen Erfolg verspricht,
      2. die sofortige Kündigung aus besonderen Gründen unter Abwägung der beiderseitigen Interessen gerechtfertigt ist oder
      3. der Mieter mit der Entrichtung der Miete im Sinne des Absatzes 2 Nr. 3 in Verzug ist.
      (4) Auf das dem Mieter nach Absatz 2 Nr. 1 zustehende Kündigungsrecht sind die §§ 536b und 536d entsprechend anzuwenden. Ist streitig, ob der Vermieter den Gebrauch der Mietsache rechtzeitig gewährt oder die Abhilfe vor Ablauf der hierzu bestimmten Frist bewirkt hat, so trifft ihn die Beweislast.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 544 Vertrag über mehr als 30 Jahre',
    content: <<~LAW_TEXT
      Wird ein Mietvertrag für eine längere Zeit als 30 Jahre geschlossen, so kann jede Vertragspartei nach Ablauf von 30 Jahren nach Überlassung der Mietsache das Mietverhältnis außerordentlich mit der gesetzlichen Frist kündigen. Die Kündigung ist unzulässig, wenn der Vertrag für die Lebenszeit des Vermieters oder des Mieters geschlossen worden ist.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 545 Stillschweigende Verlängerung des Mietverhältnisses',
    content: <<~LAW_TEXT
      Setzt der Mieter nach Ablauf der Mietzeit den Gebrauch der Mietsache fort, so verlängert sich das Mietverhältnis auf unbestimmte Zeit, sofern nicht eine Vertragspartei ihren entgegenstehenden Willen innerhalb von zwei Wochen dem anderen Teil erklärt. Die Frist beginnt
      1. für den Mieter mit der Fortsetzung des Gebrauchs,
      2. für den Vermieter mit dem Zeitpunkt, in dem er von der Fortsetzung Kenntnis erhält.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 546 Rückgabepflicht des Mieters',
    content: <<~LAW_TEXT
      (1) Der Mieter ist verpflichtet, die Mietsache nach Beendigung des Mietverhältnisses zurückzugeben.
      (2) Hat der Mieter den Gebrauch der Mietsache einem Dritten überlassen, so kann der Vermieter die Sache nach Beendigung des Mietverhältnisses auch von dem Dritten zurückfordern.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 546a Entschädigung des Vermieters bei verspäteter Rückgabe',
    content: <<~LAW_TEXT
      (1) Gibt der Mieter die Mietsache nach Beendigung des Mietverhältnisses nicht zurück, so kann der Vermieter für die Dauer der Vorenthaltung als Entschädigung die vereinbarte Miete oder die Miete verlangen, die für vergleichbare Sachen ortsüblich ist.
      (2) Die Geltendmachung eines weiteren Schadens ist nicht ausgeschlossen.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 547 Erstattung von im Voraus entrichteter Miete',
    content: <<~LAW_TEXT
      (1) Ist die Miete für die Zeit nach Beendigung des Mietverhältnisses im Voraus entrichtet worden, so hat der Vermieter sie zurückzuerstatten und ab Empfang zu verzinsen. Hat der Vermieter die Beendigung des Mietverhältnisses nicht zu vertreten, so hat er das Erlangte nach den Vorschriften über die Herausgabe einer ungerechtfertigten Bereicherung zurückzuerstatten.
      (2) Bei einem Mietverhältnis über Wohnraum ist eine zum Nachteil des Mieters abweichende Vereinbarung unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 548 Verjährung der Ersatzansprüche und des Wegnahmerechts',
    content: <<~LAW_TEXT
      (1) Die Ersatzansprüche des Vermieters wegen Veränderungen oder Verschlechterungen der Mietsache verjähren in sechs Monaten. Die Verjährung beginnt mit dem Zeitpunkt, in dem er die Mietsache zurückerhält. Mit der Verjährung des Anspruchs des Vermieters auf Rückgabe der Mietsache verjähren auch seine Ersatzansprüche.
      (2) Ansprüche des Mieters auf Ersatz von Aufwendungen oder auf Gestattung der Wegnahme einer Einrichtung verjähren in sechs Monaten nach der Beendigung des Mietverhältnisses.
      (3) (aufgehoben)
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 1\nAllgemeine Vorschriften für Mietverhältnisse",
    paragraph_title: '§ 548a Miete digitaler Produkte',
    content: <<~LAW_TEXT
      Die Vorschriften über die Miete von Sachen sind auf die Miete digitaler Produkte entsprechend anzuwenden.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 549 Auf Wohnraummietverhältnisse anwendbare Vorschriften',
    content: <<~LAW_TEXT
      (1) Für Mietverhältnisse über Wohnraum gelten die §§ 535 bis 548, soweit sich nicht aus den §§ 549 bis 577a etwas anderes ergibt.
      (2) Die Vorschriften über die Miethöhe bei Mietbeginn in Gebieten mit angespannten Wohnungsmärkten (§§ 556d bis 556g), über die Mieterhöhung (§§ 557 bis 561) und über den Mieterschutz bei Beendigung des Mietverhältnisses sowie bei der Begründung von Wohnungseigentum (§ 568 Abs. 2, §§ 573, 573a, 573d Abs. 1, §§ 574 bis 575, 575a Abs. 1 und §§ 577, 577a) gelten nicht für Mietverhältnisse über
      1. Wohnraum, der nur zum vorübergehenden Gebrauch vermietet ist,
      2. Wohnraum, der Teil der vom Vermieter selbst bewohnten Wohnung ist und den der Vermieter überwiegend mit Einrichtungsgegenständen auszustatten hat, sofern der Wohnraum dem Mieter nicht zum dauernden Gebrauch mit seiner Familie oder mit Personen überlassen ist, mit denen er einen auf Dauer angelegten gemeinsamen Haushalt führt,
      3. Wohnraum, den eine juristische Person des öffentlichen Rechts oder ein anerkannter privater Träger der Wohlfahrtspflege angemietet hat, um ihn Personen mit dringendem Wohnungsbedarf zu überlassen, wenn sie den Mieter bei Vertragsschluss auf die Zweckbestimmung des Wohnraums und die Ausnahme von den genannten Vorschriften hingewiesen hat.
      (3) Für Wohnraum in einem Studenten- oder Jugendwohnheim gelten die §§ 556d bis 561 sowie die §§ 573, 573a, 573d Abs. 1 und §§ 575, 575a Abs. 1, §§ 577, 577a nicht.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 550 Form des Mietvertrags',
    content: <<~LAW_TEXT
      Wird der Mietvertrag für längere Zeit als ein Jahr nicht in schriftlicher Form geschlossen, so gilt er für unbestimmte Zeit. Die Kündigung ist jedoch frühestens zum Ablauf eines Jahres nach Überlassung des Wohnraums zulässig.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 551 Begrenzung und Anlage von Mietsicherheiten',
    content: <<~LAW_TEXT
      (1) Hat der Mieter dem Vermieter für die Erfüllung seiner Pflichten Sicherheit zu leisten, so darf diese vorbehaltlich des Absatzes 3 Satz 4 höchstens das Dreifache der auf einen Monat entfallenden Miete ohne die als Pauschale oder als Vorauszahlung ausgewiesenen Betriebskosten betragen.
      (2) Ist als Sicherheit eine Geldsumme bereitzustellen, so ist der Mieter zu drei gleichen monatlichen Teilzahlungen berechtigt. Die erste Teilzahlung ist zu Beginn des Mietverhältnisses fällig. Die weiteren Teilzahlungen werden zusammen mit den unmittelbar folgenden Mietzahlungen fällig.
      (3) Der Vermieter hat eine ihm als Sicherheit überlassene Geldsumme bei einem Kreditinstitut zu dem für Spareinlagen mit dreimonatiger Kündigungsfrist üblichen Zinssatz anzulegen. Die Vertragsparteien können eine andere Anlageform vereinbaren. In beiden Fällen muss die Anlage vom Vermögen des Vermieters getrennt erfolgen und stehen die Erträge dem Mieter zu. Sie erhöhen die Sicherheit. Bei Wohnraum in einem Studenten- oder Jugendwohnheim besteht für den Vermieter keine Pflicht, die Sicherheitsleistung zu verzinsen.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 552 Abwendung des Wegnahmerechts des Mieters',
    content: <<~LAW_TEXT
      (1) Der Vermieter kann die Ausübung des Wegnahmerechts (§ 539 Abs. 2) durch Zahlung einer angemessenen Entschädigung abwenden, wenn nicht der Mieter ein berechtigtes Interesse an der Wegnahme hat.
      (2) Eine Vereinbarung, durch die das Wegnahmerecht ausgeschlossen wird, ist nur wirksam, wenn ein angemessener Ausgleich vorgesehen ist.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 553 Gestattung der Gebrauchsüberlassung an Dritte',
    content: <<~LAW_TEXT
      (1) Entsteht für den Mieter nach Abschluss des Mietvertrags ein berechtigtes Interesse, einen Teil des Wohnraums einem Dritten zum Gebrauch zu überlassen, so kann er von dem Vermieter die Erlaubnis hierzu verlangen. Dies gilt nicht, wenn in der Person des Dritten ein wichtiger Grund vorliegt, der Wohnraum übermäßig belegt würde oder dem Vermieter die Überlassung aus sonstigen Gründen nicht zugemutet werden kann.
      (2) Ist dem Vermieter die Überlassung nur bei einer angemessenen Erhöhung der Miete zuzumuten, so kann er die Erlaubnis davon abhängig machen, dass der Mieter sich mit einer solchen Erhöhung einverstanden erklärt.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 554 Barrierereduzierung, E-Mobilität, Einbruchsschutz und Steckersolargeräte',
    content: <<~LAW_TEXT
      (1) Der Mieter kann verlangen, dass ihm der Vermieter bauliche Veränderungen der Mietsache erlaubt, die dem Gebrauch durch Menschen mit Behinderungen, dem Laden elektrisch betriebener Fahrzeuge, dem Einbruchsschutz oder der Stromerzeugung durch Steckersolargeräte dienen. Der Anspruch besteht nicht, wenn die bauliche Veränderung dem Vermieter auch unter Würdigung der Interessen des Mieters nicht zugemutet werden kann. Der Mieter kann sich im Zusammenhang mit der baulichen Veränderung zur Leistung einer besonderen Sicherheit verpflichten; § 551 Absatz 3 gilt entsprechend.
      (2) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 555 Unwirksamkeit einer Vertragsstrafe',
    content: <<~LAW_TEXT
      Eine Vereinbarung, durch die sich der Vermieter eine Vertragsstrafe vom Mieter versprechen lässt, ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555a Erhaltungsmaßnahmen',
    content: <<~LAW_TEXT
      (1) Der Mieter hat Maßnahmen zu dulden, die zur Instandhaltung oder Instandsetzung der Mietsache erforderlich sind (Erhaltungsmaßnahmen).
      (2) Erhaltungsmaßnahmen sind dem Mieter rechtzeitig anzukündigen, es sei denn, sie sind nur mit einer unerheblichen Einwirkung auf die Mietsache verbunden oder ihre sofortige Durchführung ist zwingend erforderlich.
      (3) Aufwendungen, die der Mieter infolge einer Erhaltungsmaßnahme machen muss, hat der Vermieter in angemessenem Umfang zu ersetzen. Auf Verlangen hat er Vorschuss zu leisten.
      (4) Eine zum Nachteil des Mieters von Absatz 2 oder 3 abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555b Modernisierungsmaßnahmen',
    content: <<~LAW_TEXT
      Modernisierungsmaßnahmen sind bauliche Veränderungen,
      1. durch die in Bezug auf die Mietsache Endenergie nachhaltig eingespart wird (energetische Modernisierung),
      1a. durch die eine Heizungsanlage im Sinne des § 42 des Gebäudemodernisierungsgesetzes vom 8. August 2020 (BGBl. I S. 1728), das zuletzt durch Artikel 4 des Gesetzes vom 23. Juli 2026 (BGBl. 2026 I Nr. 226) geändert worden ist, in der jeweils geltenden Fassung, eingebaut oder aufgestellt wird,
      2. durch die nicht erneuerbare Primärenergie nachhaltig eingespart oder das Klima nachhaltig geschützt wird, sofern nicht bereits eine energetische Modernisierung nach Nummer 1 vorliegt,
      3. durch die der Wasserverbrauch nachhaltig reduziert wird,
      4. durch die der Gebrauchswert der Mietsache nachhaltig erhöht wird,
      4a. durch die die Mietsache erstmalig mittels Glasfaser an ein öffentliches Netz mit sehr hoher Kapazität im Sinne des § 3 Nummer 33 des Telekommunikationsgesetzes angeschlossen wird,
      5. durch die die allgemeinen Wohnverhältnisse auf Dauer verbessert werden,
      6. die auf Grund von Umständen durchgeführt werden, die der Vermieter nicht zu vertreten hat, und die keine Erhaltungsmaßnahmen nach § 555a sind, oder
      7. durch die neuer Wohnraum geschaffen wird.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555c Ankündigung von Modernisierungsmaßnahmen',
    content: <<~LAW_TEXT
      (1) Der Vermieter hat dem Mieter eine Modernisierungsmaßnahme spätestens drei Monate vor ihrem Beginn in Textform anzukündigen (Modernisierungsankündigung). Die Modernisierungsankündigung muss Angaben enthalten über:
      1. die Art und den voraussichtlichen Umfang der Modernisierungsmaßnahme in wesentlichen Zügen,
      2. den voraussichtlichen Beginn und die voraussichtliche Dauer der Modernisierungsmaßnahme,
      3. den Betrag der zu erwartenden Mieterhöhung, sofern eine Erhöhung nach § 559 oder § 559c verlangt werden soll, sowie die voraussichtlichen künftigen Betriebskosten.
      (2) Der Vermieter soll den Mieter in der Modernisierungsankündigung auf die Form und die Frist des Härteeinwands nach § 555d Absatz 3 Satz 1 hinweisen.
      (3) In der Modernisierungsankündigung für eine Modernisierungsmaßnahme nach § 555b Nummer 1 und 2 kann der Vermieter insbesondere hinsichtlich der energetischen Qualität von Bauteilen auf allgemein anerkannte Pauschalwerte Bezug nehmen.
      (4) Die Absätze 1 bis 3 gelten nicht für Modernisierungsmaßnahmen, die nur mit einer unerheblichen Einwirkung auf die Mietsache verbunden sind und nur zu einer unerheblichen Mieterhöhung führen.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555d Duldung von Modernisierungsmaßnahmen, Ausschlussfrist',
    content: <<~LAW_TEXT
      (1) Der Mieter hat eine Modernisierungsmaßnahme zu dulden.
      (2) Eine Duldungspflicht nach Absatz 1 besteht nicht, wenn die Modernisierungsmaßnahme für den Mieter, seine Familie oder einen Angehörigen seines Haushalts eine Härte bedeuten würde, die auch unter Würdigung der berechtigten Interessen sowohl des Vermieters als auch anderer Mieter in dem Gebäude sowie von Belangen der Energieeinsparung und des Klimaschutzes nicht zu rechtfertigen ist. Die zu erwartende Mieterhöhung sowie die voraussichtlichen künftigen Betriebskosten bleiben bei der Abwägung im Rahmen der Duldungspflicht außer Betracht; sie sind nur nach § 559 Absatz 4 und 5 bei einer Mieterhöhung zu berücksichtigen.
      (3) Der Mieter hat dem Vermieter Umstände, die eine Härte im Hinblick auf die Duldung oder die Mieterhöhung begründen, bis zum Ablauf des Monats, der auf den Zugang der Modernisierungsankündigung folgt, in Textform mitzuteilen. Der Lauf der Frist beginnt nur, wenn die Modernisierungsankündigung den Vorschriften des § 555c entspricht.
      (4) Nach Ablauf der Frist sind Umstände, die eine Härte im Hinblick auf die Duldung oder die Mieterhöhung begründen, noch zu berücksichtigen, wenn der Mieter ohne Verschulden an der Einhaltung der Frist gehindert war und er dem Vermieter die Umstände sowie die Gründe der Verzögerung unverzüglich in Textform mitteilt. Umstände, die eine Härte im Hinblick auf die Mieterhöhung begründen, sind nur zu berücksichtigen, wenn sie spätestens bis zum Beginn der Modernisierungsmaßnahme mitgeteilt werden.
      (5) Hat der Vermieter in der Modernisierungsankündigung nicht auf die Form und die Frist des Härteeinwands hingewiesen (§ 555c Absatz 2), so bedarf die Mitteilung des Mieters nach Absatz 3 Satz 1 nicht der dort bestimmten Form und Frist. Absatz 4 Satz 2 gilt entsprechend.
      (6) § 555a Absatz 3 gilt entsprechend.
      (7) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555e Sonderkündigungsrecht des Mieters bei Modernisierungsmaßnahmen',
    content: <<~LAW_TEXT
      (1) Nach Zugang der Modernisierungsankündigung kann der Mieter das Mietverhältnis außerordentlich zum Ablauf des übernächsten Monats kündigen. Die Kündigung muss bis zum Ablauf des Monats erfolgen, der auf den Zugang der Modernisierungsankündigung folgt.
      (2) § 555c Absatz 4 gilt entsprechend.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 1a\nErhaltungs- und Modernisierungsmaßnahmen",
    paragraph_title: '§ 555f Vereinbarungen über Erhaltungs- oder Modernisierungsmaßnahmen',
    content: <<~LAW_TEXT
      Die Vertragsparteien können nach Abschluss des Mietvertrags aus Anlass von Erhaltungs- oder Modernisierungsmaßnahmen Vereinbarungen treffen, insbesondere über die
      1. zeitliche und technische Durchführung der Maßnahmen,
      2. Gewährleistungsrechte und Aufwendungsersatzansprüche des Mieters,
      3. künftige Höhe der Miete.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nVereinbarungen über die Miete",
    paragraph_title: '§ 556 Vereinbarungen über Betriebskosten',
    content: <<~LAW_TEXT
      (1) Die Vertragsparteien können vereinbaren, dass der Mieter Betriebskosten trägt. Betriebskosten sind die Kosten, die dem Eigentümer oder Erbbauberechtigten durch das Eigentum oder das Erbbaurecht am Grundstück oder durch den bestimmungsmäßigen Gebrauch des Gebäudes, der Nebengebäude, Anlagen, Einrichtungen und des Grundstücks laufend entstehen. Für die Aufstellung der Betriebskosten gilt die Betriebskostenverordnung vom 25. November 2003 (BGBl. I S. 2346, 2347) fort. Die Bundesregierung wird ermächtigt, durch Rechtsverordnung ohne Zustimmung des Bundesrates Vorschriften über die Aufstellung der Betriebskosten zu erlassen.
      (2) Die Vertragsparteien können vorbehaltlich anderweitiger Vorschriften vereinbaren, dass Betriebskosten als Pauschale oder als Vorauszahlung ausgewiesen werden. Vorauszahlungen für Betriebskosten dürfen nur in angemessener Höhe vereinbart werden.
      (3) Über die Vorauszahlungen für Betriebskosten ist jährlich abzurechnen; dabei ist der Grundsatz der Wirtschaftlichkeit zu beachten. Die Abrechnung ist dem Mieter spätestens bis zum Ablauf des zwölften Monats nach Ende des Abrechnungszeitraums mitzuteilen. Nach Ablauf dieser Frist ist die Geltendmachung einer Nachforderung durch den Vermieter ausgeschlossen, es sei denn, der Vermieter hat die verspätete Geltendmachung nicht zu vertreten. Der Vermieter ist zu Teilabrechnungen nicht verpflichtet. Einwendungen gegen die Abrechnung hat der Mieter dem Vermieter spätestens bis zum Ablauf des zwölften Monats nach Zugang der Abrechnung mitzuteilen. Nach Ablauf dieser Frist kann der Mieter Einwendungen nicht mehr geltend machen, es sei denn, der Mieter hat die verspätete Geltendmachung nicht zu vertreten.
      (3a) Ein Glasfaserbereitstellungsentgelt nach § 72 Absatz 1 des Telekommunikationsgesetzes hat der Mieter nur bei wirtschaftlicher Umsetzung der Maßnahme zu tragen. Handelt es sich um eine aufwändige Maßnahme im Sinne von § 72 Absatz 2 Satz 4 des Telekommunikationsgesetzes, hat der Mieter die Kosten nur dann zu tragen, wenn der Vermieter vor Vereinbarung der Glasfaserbereitstellung soweit möglich drei Angebote eingeholt und das wirtschaftlichste ausgewählt hat.
      (4) Der Vermieter hat dem Mieter auf Verlangen Einsicht in die der Abrechnung zugrundeliegenden Belege zu gewähren. Der Vermieter ist berechtigt, die Belege elektronisch bereitzustellen.
      (5) Eine zum Nachteil des Mieters von Absatz 1, Absatz 2 Satz 2, Absatz 3 oder Absatz 3a abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nVereinbarungen über die Miete",
    paragraph_title: '§ 556a Abrechnungsmaßstab für Betriebskosten',
    content: <<~LAW_TEXT
      (1) Haben die Vertragsparteien nichts anderes vereinbart, sind die Betriebskosten vorbehaltlich anderweitiger Vorschriften nach dem Anteil der Wohnfläche umzulegen. Betriebskosten, die von einem erfassten Verbrauch oder einer erfassten Verursachung durch die Mieter abhängen, sind nach einem Maßstab umzulegen, der dem unterschiedlichen Verbrauch oder der unterschiedlichen Verursachung Rechnung trägt.
      (2) Haben die Vertragsparteien etwas anderes vereinbart, kann der Vermieter durch Erklärung in Textform bestimmen, dass die Betriebskosten zukünftig abweichend von der getroffenen Vereinbarung ganz oder teilweise nach einem Maßstab umgelegt werden dürfen, der dem erfassten unterschiedlichen Verbrauch oder der erfassten unterschiedlichen Verursachung Rechnung trägt. Die Erklärung ist nur vor Beginn eines Abrechnungszeitraums zulässig. Sind die Kosten bislang in der Miete enthalten, so ist diese entsprechend herabzusetzen.
      (3) Ist Wohnungseigentum vermietet und haben die Vertragsparteien nichts anderes vereinbart, sind die Betriebskosten abweichend von Absatz 1 nach dem für die Verteilung zwischen den Wohnungseigentümern jeweils geltenden Maßstab umzulegen. Widerspricht der Maßstab billigem Ermessen, ist nach Absatz 1 umzulegen.
      (4) Eine zum Nachteil des Mieters von Absatz 2 abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nVereinbarungen über die Miete",
    paragraph_title: '§ 556b Fälligkeit der Miete, Aufrechnungs- und Zurückbehaltungsrecht',
    content: <<~LAW_TEXT
      (1) Die Miete ist zu Beginn, spätestens bis zum dritten Werktag der einzelnen Zeitabschnitte zu entrichten, nach denen sie bemessen ist.
      (2) Der Mieter kann entgegen einer vertraglichen Bestimmung gegen eine Mietforderung mit einer Forderung auf Grund der §§ 536a, 539 oder aus ungerechtfertigter Bereicherung wegen zu viel gezahlter Miete aufrechnen oder wegen einer solchen Forderung ein Zurückbehaltungsrecht ausüben, wenn er seine Absicht dem Vermieter mindestens einen Monat vor der Fälligkeit der Miete in Textform angezeigt hat. Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nVereinbarungen über die Miete",
    paragraph_title: '§ 556c Kosten der Wärmelieferung als Betriebskosten, Verordnungsermächtigung',
    content: <<~LAW_TEXT
      (1) Hat der Mieter die Betriebskosten für Wärme oder Warmwasser zu tragen und stellt der Vermieter die Versorgung von der Eigenversorgung auf die eigenständig gewerbliche Lieferung durch einen Wärmelieferanten (Wärmelieferung) um, so hat der Mieter die Kosten der Wärmelieferung als Betriebskosten zu tragen, wenn
      1. die Wärme mit verbesserter Effizienz entweder aus einer vom Wärmelieferanten errichteten neuen Anlage oder aus einem Wärmenetz geliefert wird und
      2. die Kosten der Wärmelieferung die Betriebskosten für die bisherige Eigenversorgung mit Wärme oder Warmwasser nicht übersteigen.
      Beträgt der Jahresnutzungsgrad der bestehenden Anlage vor der Umstellung mindestens 80 Prozent, kann sich der Wärmelieferant anstelle der Maßnahmen nach Nummer 1 auf die Verbesserung der Betriebsführung der Anlage beschränken.
      (2) Der Vermieter hat die Umstellung spätestens drei Monate zuvor in Textform anzukündigen (Umstellungsankündigung).
      (3) Die Bundesregierung wird ermächtigt, durch Rechtsverordnung ohne Zustimmung des Bundesrates Vorschriften für Wärmelieferverträge, die bei einer Umstellung nach Absatz 1 geschlossen werden, sowie für die Anforderungen nach den Absätzen 1 und 2 zu erlassen. Hierbei sind die Belange von Vermietern, Mietern und Wärmelieferanten angemessen zu berücksichtigen.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1a\nVereinbarungen über die Miethöhe bei Mietbeginn in Gebieten mit angespannten Wohnungsmärkten",
    paragraph_title: '§ 556d Zulässige Miethöhe bei Mietbeginn; Verordnungsermächtigung',
    content: <<~LAW_TEXT
      (1) Wird ein Mietvertrag über Wohnraum abgeschlossen, der in einem durch Rechtsverordnung nach Absatz 2 bestimmten Gebiet mit einem angespannten Wohnungsmarkt liegt, so darf die Miete zu Beginn des Mietverhältnisses die ortsübliche Vergleichsmiete (§ 558 Absatz 2) höchstens um 10 Prozent übersteigen.
      (2) Die Landesregierungen werden ermächtigt, Gebiete mit angespannten Wohnungsmärkten durch Rechtsverordnung zu bestimmen. Gebiete mit angespannten Wohnungsmärkten liegen vor, wenn die ausreichende Versorgung der Bevölkerung mit Mietwohnungen in einer Gemeinde oder einem Teil der Gemeinde zu angemessenen Bedingungen besonders gefährdet ist. Dies kann insbesondere dann der Fall sein, wenn
      1. die Mieten deutlich stärker steigen als im bundesweiten Durchschnitt,
      2. die durchschnittliche Mietbelastung der Haushalte den bundesweiten Durchschnitt deutlich übersteigt,
      3. die Wohnbevölkerung wächst, ohne dass durch Neubautätigkeit insoweit erforderlicher Wohnraum geschaffen wird, oder
      4. geringer Leerstand bei großer Nachfrage besteht.
      Eine Rechtsverordnung nach Satz 1 muss spätestens mit Ablauf des 31. Dezember 2029 außer Kraft treten. Sie muss begründet werden. Aus der Begründung muss sich ergeben, auf Grund welcher Tatsachen ein Gebiet mit einem angespannten Wohnungsmarkt im Einzelfall vorliegt. Ferner muss sich aus der Begründung ergeben, welche Maßnahmen die Landesregierung in dem nach Satz 1 durch die Rechtsverordnung jeweils bestimmten Gebiet und Zeitraum ergreifen wird, um Abhilfe zu schaffen.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1a\nVereinbarungen über die Miethöhe bei Mietbeginn in Gebieten mit angespannten Wohnungsmärkten",
    paragraph_title: '§ 556e Berücksichtigung der Vormiete oder einer durchgeführten Modernisierung',
    content: <<~LAW_TEXT
      (1) Ist die Miete, die der vorherige Mieter zuletzt schuldete (Vormiete), höher als die nach § 556d Absatz 1 zulässige Miete, so darf eine Miete bis zur Höhe der Vormiete vereinbart werden. Bei der Ermittlung der Vormiete unberücksichtigt bleiben Mietminderungen sowie solche Mieterhöhungen, die mit dem vorherigen Mieter innerhalb des letzten Jahres vor Beendigung des Mietverhältnisses vereinbart worden sind.
      (2) Hat der Vermieter in den letzten drei Jahren vor Beginn des Mietverhältnisses Modernisierungsmaßnahmen im Sinne des § 555b durchgeführt, so darf die nach § 556d Absatz 1 zulässige Miete um den Betrag überschritten werden, der sich bei einer Mieterhöhung nach § 559 Absatz 1 bis 3a und § 559a Absatz 1 bis 4 ergäbe. Bei der Berechnung nach Satz 1 ist von der ortsüblichen Vergleichsmiete (§ 558 Absatz 2) auszugehen, die bei Beginn des Mietverhältnisses ohne Berücksichtigung der Modernisierung anzusetzen wäre.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1a\nVereinbarungen über die Miethöhe bei Mietbeginn in Gebieten mit angespannten Wohnungsmärkten",
    paragraph_title: '§ 556f Ausnahmen',
    content: <<~LAW_TEXT
      § 556d ist nicht anzuwenden auf eine Wohnung, die nach dem 1. Oktober 2014 erstmals genutzt und vermietet wird. Die §§ 556d und 556e sind nicht anzuwenden auf die erste Vermietung nach umfassender Modernisierung.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1a\nVereinbarungen über die Miethöhe bei Mietbeginn in Gebieten mit angespannten Wohnungsmärkten",
    paragraph_title: '§ 556g Rechtsfolgen; Auskunft über die Miete',
    content: <<~LAW_TEXT
      (1) Eine zum Nachteil des Mieters von den Vorschriften dieses Unterkapitels abweichende Vereinbarung ist unwirksam. Für Vereinbarungen über die Miethöhe bei Mietbeginn gilt dies nur, soweit die zulässige Miete überschritten wird. Der Vermieter hat dem Mieter zu viel gezahlte Miete nach den Vorschriften über die Herausgabe einer ungerechtfertigten Bereicherung herauszugeben. Die §§ 814 und 817 Satz 2 sind nicht anzuwenden.
      (1a) Soweit die Zulässigkeit der Miete auf § 556e oder § 556f beruht, ist der Vermieter verpflichtet, dem Mieter vor dessen Abgabe der Vertragserklärung über Folgendes unaufgefordert Auskunft zu erteilen:
      1. im Fall des § 556e Absatz 1 darüber, wie hoch die Vormiete war,
      2. im Fall des § 556e Absatz 2 darüber, dass in den letzten drei Jahren vor Beginn des Mietverhältnisses Modernisierungsmaßnahmen durchgeführt wurden,
      3. im Fall des § 556f Satz 1 darüber, dass die Wohnung nach dem 1. Oktober 2014 erstmals genutzt und vermietet wurde,
      4. im Fall des § 556f Satz 2 darüber, dass es sich um die erste Vermietung nach umfassender Modernisierung handelt.
      Soweit der Vermieter die Auskunft nicht erteilt hat, kann er sich nicht auf eine nach § 556e oder § 556f zulässige Miete berufen. Hat der Vermieter die Auskunft nicht erteilt und hat er diese in der vorgeschriebenen Form nachgeholt, kann er sich erst zwei Jahre nach Nachholung der Auskunft auf eine nach § 556e oder § 556f zulässige Miete berufen. Hat der Vermieter die Auskunft nicht in der vorgeschriebenen Form erteilt, so kann er sich auf eine nach § 556e oder § 556f zulässige Miete erst dann berufen, wenn er die Auskunft in der vorgeschriebenen Form nachgeholt hat.
      (2) Der Mieter kann von dem Vermieter eine nach den §§ 556d und 556e nicht geschuldete Miete nur zurückverlangen, wenn er einen Verstoß gegen die Vorschriften dieses Unterkapitels gerügt hat. Hat der Vermieter eine Auskunft nach Absatz 1a Satz 1 erteilt, so muss die Rüge sich auf diese Auskunft beziehen. Rügt der Mieter den Verstoß mehr als 30 Monate nach Beginn des Mietverhältnisses oder war das Mietverhältnis bei Zugang der Rüge bereits beendet, kann er nur die nach Zugang der Rüge fällig gewordene Miete zurückverlangen.
      (3) Der Vermieter ist auf Verlangen des Mieters verpflichtet, Auskunft über diejenigen Tatsachen zu erteilen, die für die Zulässigkeit der vereinbarten Miete nach den Vorschriften dieses Unterkapitels maßgeblich sind, soweit diese Tatsachen nicht allgemein zugänglich sind und der Vermieter hierüber unschwer Auskunft geben kann. Für die Auskunft über Modernisierungsmaßnahmen (§ 556e Absatz 2) gilt § 559b Absatz 1 Satz 2 und 3 entsprechend.
      (4) Sämtliche Erklärungen nach den Absätzen 1a bis 3 bedürfen der Textform.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 557 Mieterhöhungen nach Vereinbarung oder Gesetz',
    content: <<~LAW_TEXT
      (1) Während des Mietverhältnisses können die Parteien eine Erhöhung der Miete vereinbaren.
      (2) Künftige Änderungen der Miethöhe können die Vertragsparteien als Staffelmiete nach § 557a oder als Indexmiete nach § 557b vereinbaren.
      (3) Im Übrigen kann der Vermieter Mieterhöhungen nur nach Maßgabe der §§ 558 bis 560 verlangen, soweit nicht eine Erhöhung durch Vereinbarung ausgeschlossen ist oder sich der Ausschluss aus den Umständen ergibt.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 557a Staffelmiete',
    content: <<~LAW_TEXT
      (1) Die Miete kann für bestimmte Zeiträume in unterschiedlicher Höhe schriftlich vereinbart werden; in der Vereinbarung ist die jeweilige Miete oder die jeweilige Erhöhung in einem Geldbetrag auszuweisen (Staffelmiete).
      (2) Die Miete muss jeweils mindestens ein Jahr unverändert bleiben. Während der Laufzeit einer Staffelmiete ist eine Erhöhung nach den §§ 558 bis 559b ausgeschlossen.
      (3) Das Kündigungsrecht des Mieters kann für höchstens vier Jahre seit Abschluss der Staffelmietvereinbarung ausgeschlossen werden. Die Kündigung ist frühestens zum Ablauf dieses Zeitraums zulässig.
      (4) Die §§ 556d bis 556g sind auf jede Mietstaffel anzuwenden. Maßgeblich für die Berechnung der nach § 556d Absatz 1 zulässigen Höhe der zweiten und aller weiteren Mietstaffeln ist statt des Beginns des Mietverhältnisses der Zeitpunkt, zu dem die erste Miete der jeweiligen Mietstaffel fällig wird. Die in einer vorangegangenen Mietstaffel wirksam begründete Miethöhe bleibt erhalten.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 557b Indexmiete',
    content: <<~LAW_TEXT
      (1) Die Vertragsparteien können schriftlich vereinbaren, dass die Miete durch den vom Statistischen Bundesamt ermittelten Preisindex für die Lebenshaltung aller privaten Haushalte in Deutschland bestimmt wird (Indexmiete).
      (2) Während der Geltung einer Indexmiete muss die Miete, von Erhöhungen nach den §§ 559 bis 560 abgesehen, jeweils mindestens ein Jahr unverändert bleiben. Eine Erhöhung nach § 559 oder § 559e kann nur verlangt werden, soweit der Vermieter bauliche Maßnahmen auf Grund von Umständen durchgeführt hat, die er nicht zu vertreten hat, es sei denn, es wurde eine Modernisierungsmaßnahme nach § 555b Nummer 1a durchgeführt. Eine Erhöhung nach § 558 ist ausgeschlossen.
      (3) Eine Änderung der Miete nach Absatz 1 muss durch Erklärung in Textform geltend gemacht werden. Dabei sind die eingetretene Änderung des Preisindexes sowie die jeweilige Miete oder die Erhöhung in einem Geldbetrag anzugeben. Die geänderte Miete ist mit Beginn des übernächsten Monats nach dem Zugang der Erklärung zu entrichten.
      (4) Die §§ 556d bis 556g sind nur auf die Ausgangsmiete einer Indexmietvereinbarung anzuwenden.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558 Mieterhöhung bis zur ortsüblichen Vergleichsmiete',
    content: <<~LAW_TEXT
      (1) Der Vermieter kann die Zustimmung zu einer Erhöhung der Miete bis zur ortsüblichen Vergleichsmiete verlangen, wenn die Miete in dem Zeitpunkt, zu dem die Erhöhung eintreten soll, seit 15 Monaten unverändert ist. Das Mieterhöhungsverlangen kann frühestens ein Jahr nach der letzten Mieterhöhung geltend gemacht werden. Erhöhungen nach den §§ 559 bis 560 werden nicht berücksichtigt.
      (2) Die ortsübliche Vergleichsmiete wird gebildet aus den üblichen Entgelten, die in der Gemeinde oder einer vergleichbaren Gemeinde für Wohnraum vergleichbarer Art, Größe, Ausstattung, Beschaffenheit und Lage einschließlich der energetischen Ausstattung und Beschaffenheit in den letzten sechs Jahren vereinbart oder, von Erhöhungen nach § 560 abgesehen, geändert worden sind. Ausgenommen ist Wohnraum, bei dem die Miethöhe durch Gesetz oder im Zusammenhang mit einer Förderzusage festgelegt worden ist.
      (3) Bei Erhöhungen nach Absatz 1 darf sich die Miete innerhalb von drei Jahren, von Erhöhungen nach den §§ 559 bis 560 abgesehen, nicht um mehr als 20 vom Hundert erhöhen (Kappungsgrenze). Der Prozentsatz nach Satz 1 beträgt 15 vom Hundert, wenn die ausreichende Versorgung der Bevölkerung mit Mietwohnungen zu angemessenen Bedingungen in einer Gemeinde oder einem Teil einer Gemeinde besonders gefährdet ist und diese Gebiete nach Satz 3 bestimmt sind. Die Landesregierungen werden ermächtigt, diese Gebiete durch Rechtsverordnung für die Dauer von jeweils höchstens fünf Jahren zu bestimmen.
      (4) Die Kappungsgrenze gilt nicht,
      1. wenn eine Verpflichtung des Mieters zur Ausgleichszahlung nach den Vorschriften über den Abbau der Fehlsubventionierung im Wohnungswesen wegen des Wegfalls der öffentlichen Bindung erloschen ist und
      2. soweit die Erhöhung den Betrag der zuletzt zu entrichtenden Ausgleichszahlung nicht übersteigt.
      Der Vermieter kann vom Mieter frühestens vier Monate vor dem Wegfall der öffentlichen Bindung verlangen, ihm innerhalb eines Monats über die Verpflichtung zur Ausgleichszahlung und über deren Höhe Auskunft zu erteilen. Satz 1 gilt entsprechend, wenn die Verpflichtung des Mieters zur Leistung einer Ausgleichszahlung nach den §§ 34 bis 37 des Wohnraumförderungsgesetzes und den hierzu ergangenen landesrechtlichen Vorschriften wegen Wegfalls der Mietbindung erloschen ist.
      (5) Von dem Jahresbetrag, der sich bei einer Erhöhung auf die ortsübliche Vergleichsmiete ergäbe, sind Drittmittel im Sinne des § 559a abzuziehen, im Falle des § 559a Absatz 1 mit 8 Prozent des Zuschusses.
      (6) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558a Form und Begründung der Mieterhöhung',
    content: <<~LAW_TEXT
      (1) Das Mieterhöhungsverlangen nach § 558 ist dem Mieter in Textform zu erklären und zu begründen.
      (2) Zur Begründung kann insbesondere Bezug genommen werden auf
      1. einen Mietspiegel (§§ 558c, 558d),
      2. eine Auskunft aus einer Mietdatenbank (§ 558e),
      3. ein mit Gründen versehenes Gutachten eines öffentlich bestellten und vereidigten Sachverständigen,
      4. entsprechende Entgelte für einzelne vergleichbare Wohnungen; hierbei genügt die Benennung von drei Wohnungen.
      (3) Enthält ein qualifizierter Mietspiegel (§ 558d Abs. 1), bei dem die Vorschrift des § 558d Abs. 2 eingehalten ist, Angaben für die Wohnung, so hat der Vermieter in seinem Mieterhöhungsverlangen diese Angaben auch dann mitzuteilen, wenn er die Mieterhöhung auf ein anderes Begründungsmittel nach Absatz 2 stützt.
      (4) Bei der Bezugnahme auf einen Mietspiegel, der Spannen enthält, reicht es aus, wenn die verlangte Miete innerhalb der Spanne liegt. Ist in dem Zeitpunkt, in dem der Vermieter seine Erklärung abgibt, kein Mietspiegel vorhanden, bei dem § 558c Abs. 3 oder § 558d Abs. 2 eingehalten ist, so kann auch ein anderer, insbesondere ein veralteter Mietspiegel oder ein Mietspiegel einer vergleichbaren Gemeinde verwendet werden.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558b Zustimmung zur Mieterhöhung',
    content: <<~LAW_TEXT
      (1) Soweit der Mieter der Mieterhöhung zustimmt, schuldet er die erhöhte Miete mit Beginn des dritten Kalendermonats nach dem Zugang des Erhöhungsverlangens.
      (2) Soweit der Mieter der Mieterhöhung nicht bis zum Ablauf des zweiten Kalendermonats nach dem Zugang des Verlangens zustimmt, kann der Vermieter auf Erteilung der Zustimmung klagen. Die Klage muss innerhalb von drei weiteren Monaten erhoben werden.
      (3) Ist der Klage ein Erhöhungsverlangen vorausgegangen, das den Anforderungen des § 558a nicht entspricht, so kann es der Vermieter im Rechtsstreit nachholen oder die Mängel des Erhöhungsverlangens beheben. Dem Mieter steht auch in diesem Fall die Zustimmungsfrist nach Absatz 2 Satz 1 zu.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558c Mietspiegel; Verordnungsermächtigung',
    content: <<~LAW_TEXT
      (1) Ein Mietspiegel ist eine Übersicht über die ortsübliche Vergleichsmiete, soweit die Übersicht von der nach Landesrecht zuständigen Behörde oder von Interessenvertretern der Vermieter und der Mieter gemeinsam erstellt oder anerkannt worden ist.
      (2) Mietspiegel können für das Gebiet einer Gemeinde oder mehrerer Gemeinden oder für Teile von Gemeinden erstellt werden.
      (3) Mietspiegel sollen im Abstand von zwei Jahren der Marktentwicklung angepasst werden.
      (4) Die nach Landesrecht zuständigen Behörden sollen Mietspiegel erstellen, wenn hierfür ein Bedürfnis besteht und dies mit einem vertretbaren Aufwand möglich ist. Für Gemeinden mit mehr als 50 000 Einwohnern sind Mietspiegel zu erstellen. Die Mietspiegel und ihre Änderungen sind zu veröffentlichen.
      (5) Die Bundesregierung wird ermächtigt, durch Rechtsverordnung mit Zustimmung des Bundesrates Vorschriften zu erlassen über den näheren Inhalt von Mietspiegeln und das Verfahren zu deren Erstellung und Anpassung einschließlich Dokumentation und Veröffentlichung.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558d Qualifizierter Mietspiegel',
    content: <<~LAW_TEXT
      (1) Ein qualifizierter Mietspiegel ist ein Mietspiegel, der nach anerkannten wissenschaftlichen Grundsätzen erstellt und von der nach Landesrecht zuständigen Behörde oder von Interessenvertretern der Vermieter und der Mieter anerkannt worden ist. Entspricht ein Mietspiegel den Anforderungen, die eine nach § 558c Absatz 5 erlassene Rechtsverordnung an qualifizierte Mietspiegel richtet, wird vermutet, dass er nach anerkannten wissenschaftlichen Grundsätzen erstellt wurde. Haben die nach Landesrecht zuständige Behörde und Interessenvertreter der Vermieter und der Mieter den Mietspiegel als qualifizierten Mietspiegel anerkannt, so wird vermutet, dass der Mietspiegel anerkannten wissenschaftlichen Grundsätzen entspricht.
      (2) Der qualifizierte Mietspiegel ist im Abstand von zwei Jahren der Marktentwicklung anzupassen. Dabei kann eine Stichprobe oder die Entwicklung des vom Statistischen Bundesamt ermittelten Preisindexes für die Lebenshaltung aller privaten Haushalte in Deutschland zugrunde gelegt werden. Nach vier Jahren ist der qualifizierte Mietspiegel neu zu erstellen. Maßgeblicher Zeitpunkt für die Anpassung nach Satz 1 und für die Neuerstellung nach Satz 3 ist der Stichtag, zu dem die Daten für den Mietspiegel erhoben wurden. Satz 4 gilt entsprechend für die Veröffentlichung des Mietspiegels.
      (3) Ist die Vorschrift des Absatzes 2 eingehalten, so wird vermutet, dass die im qualifizierten Mietspiegel bezeichneten Entgelte die ortsübliche Vergleichsmiete wiedergeben.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 558e Mietdatenbank',
    content: <<~LAW_TEXT
      Eine Mietdatenbank ist eine zur Ermittlung der ortsüblichen Vergleichsmiete fortlaufend geführte Sammlung von Mieten, die von der Gemeinde oder von Interessenvertretern der Vermieter und der Mieter gemeinsam geführt oder anerkannt wird und aus der Auskünfte gegeben werden, die für einzelne Wohnungen einen Schluss auf die ortsübliche Vergleichsmiete zulassen.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559 Mieterhöhung nach Modernisierungsmaßnahmen',
    content: <<~LAW_TEXT
      (1) Hat der Vermieter Modernisierungsmaßnahmen im Sinne des § 555b Nummer 1, 3, 4, 5 oder 6 durchgeführt, so kann er die jährliche Miete um 8 Prozent der für die Wohnung aufgewendeten Kosten erhöhen. Im Fall des § 555b Nummer 4a ist die Erhöhung nur zulässig, wenn der Mieter seinen Anbieter von öffentlich zugänglichen Telekommunikationsdiensten über den errichteten Anschluss frei wählen kann und der Vermieter kein Bereitstellungsentgelt gemäß § 72 des Telekommunikationsgesetzes als Betriebskosten umlegt oder umgelegt hat.
      (2) Kosten, die für Erhaltungsmaßnahmen erforderlich gewesen wären, gehören nicht zu den aufgewendeten Kosten nach Absatz 1; sie sind, soweit erforderlich, durch Schätzung zu ermitteln. Dabei ist der Abnutzungsgrad der Bauteile und Einrichtungen, die von einer modernisierenden Erneuerung erfasst werden, angemessen zu berücksichtigen.
      (3) Werden Modernisierungsmaßnahmen für mehrere Wohnungen durchgeführt, so sind die Kosten angemessen auf die einzelnen Wohnungen aufzuteilen.
      (3a) Bei Erhöhungen der jährlichen Miete nach Absatz 1 darf sich die monatliche Miete innerhalb von sechs Jahren, von Erhöhungen nach § 558 oder § 560 abgesehen, nicht um mehr als 3 Euro je Quadratmeter Wohnfläche erhöhen. Beträgt die monatliche Miete vor der Mieterhöhung weniger als 7 Euro pro Quadratmeter Wohnfläche, so darf sie sich abweichend von Satz 1 nicht um mehr als 2 Euro je Quadratmeter Wohnfläche erhöhen. Sind bei einer Modernisierungsmaßnahme, die mittels Einbaus oder Aufstellung einer Heizungsanlage zum Zwecke der Inbetriebnahme in einem Gebäude durchgeführt wird und die zu einer Erhöhung der jährlichen Miete nach Absatz 1 berechtigt, zugleich die Voraussetzungen des § 555b Nummer 1 oder Nummer 1a erfüllt, so darf sich die monatliche Miete insoweit um nicht mehr als 0,50 Euro je Quadratmeter Wohnfläche innerhalb von sechs Jahren erhöhen; die Sätze 1 und 2 bleiben unberührt.
      (4) Die Mieterhöhung ist ausgeschlossen, soweit sie auch unter Berücksichtigung der voraussichtlichen künftigen Betriebskosten für den Mieter eine Härte bedeuten würde, die auch unter Würdigung der berechtigten Interessen des Vermieters nicht zu rechtfertigen ist. Eine Abwägung nach Satz 1 findet nicht statt, wenn
      1. die Mietsache lediglich in einen Zustand versetzt wurde, der allgemein üblich ist, oder
      2. die Modernisierungsmaßnahme auf Grund von Umständen durchgeführt wurde, die der Vermieter nicht zu vertreten hatte, es sei denn, die Modernisierungsmaßnahme erfüllt auch die Voraussetzungen des § 555b Nummer 1 oder Nummer 1a und wurde mittels Einbaus oder Aufstellung einer Heizungsanlage zum Zwecke der Inbetriebnahme in einem Gebäude durchgeführt.
      (5) Umstände, die eine Härte nach Absatz 4 Satz 1 begründen, sind nur zu berücksichtigen, wenn sie nach § 555d Absatz 3 bis 5 rechtzeitig mitgeteilt worden sind. Die Bestimmungen über die Ausschlussfrist nach Satz 1 sind nicht anzuwenden, wenn die tatsächliche Mieterhöhung die angekündigte um mehr als 10 Prozent übersteigt.
      (6) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559a Anrechnung von Drittmitteln',
    content: <<~LAW_TEXT
      (1) Kosten, die vom Mieter oder für diesen von einem Dritten übernommen oder die mit Zuschüssen aus öffentlichen Haushalten gedeckt werden, gehören nicht zu den aufgewendeten Kosten im Sinne des § 559.
      (2) Werden die Kosten für die Modernisierungsmaßnahmen ganz oder teilweise durch zinsverbilligte oder zinslose Darlehen aus öffentlichen Haushalten gedeckt, so verringert sich der Erhöhungsbetrag nach § 559 um den Jahresbetrag der Zinsermäßigung. Dieser wird errechnet aus dem Unterschied zwischen dem ermäßigten Zinssatz und dem marktüblichen Zinssatz für den Ursprungsbetrag des Darlehens. Maßgebend ist der marktübliche Zinssatz für erstrangige Hypotheken zum Zeitpunkt der Beendigung der Modernisierungsmaßnahmen. Werden Zuschüsse oder Darlehen zur Deckung von laufenden Aufwendungen gewährt, so verringert sich der Erhöhungsbetrag um den Jahresbetrag des Zuschusses oder Darlehens.
      (3) Ein Mieterdarlehen, eine Mietvorauszahlung oder eine von einem Dritten für den Mieter erbrachte Leistung für die Modernisierungsmaßnahmen stehen einem Darlehen aus öffentlichen Haushalten gleich. Mittel der Finanzierungsinstitute des Bundes oder eines Landes gelten als Mittel aus öffentlichen Haushalten.
      (4) Kann nicht festgestellt werden, in welcher Höhe Zuschüsse oder Darlehen für die einzelnen Wohnungen gewährt worden sind, so sind sie nach dem Verhältnis der für die einzelnen Wohnungen aufgewendeten Kosten aufzuteilen.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559b Geltendmachung der Erhöhung, Wirkung der Erhöhungserklärung',
    content: <<~LAW_TEXT
      (1) Die Mieterhöhung nach § 559 ist dem Mieter in Textform zu erklären. Die Erklärung ist nur wirksam, wenn in ihr die Erhöhung auf Grund der entstandenen Kosten berechnet und entsprechend den Voraussetzungen der §§ 559 und 559a erläutert wird. § 555c Absatz 3 gilt entsprechend.
      (2) Der Mieter schuldet die erhöhte Miete mit Beginn des dritten Monats nach dem Zugang der Erklärung. Die Frist verlängert sich um sechs Monate, wenn
      1. der Vermieter dem Mieter die Modernisierungsmaßnahme nicht nach den Vorschriften des § 555c Absatz 1 und 3 bis 5 angekündigt hat oder
      2. die tatsächliche Mieterhöhung die angekündigte um mehr als 10 Prozent übersteigt.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559c Vereinfachtes Verfahren',
    content: <<~LAW_TEXT
      (1) Übersteigen die für die Modernisierungsmaßnahme geltend gemachten Kosten für die Wohnung vor Abzug der Pauschale nach Satz 2 10 000 Euro nicht, so kann der Vermieter die Mieterhöhung nach einem vereinfachten Verfahren berechnen. Als Kosten, die für Erhaltungsmaßnahmen erforderlich gewesen wären (§ 559 Absatz 2), werden pauschal 30 Prozent der nach Satz 1 geltend gemachten Kosten abgezogen. § 559 Absatz 4 und § 559a Absatz 2 Satz 1 bis 3 finden keine Anwendung; dies gilt im Hinblick auf § 559 Absatz 4 nicht, wenn die Modernisierungsmaßnahme auch die Voraussetzungen des § 555b Nummer 1 oder Nummer 1a erfüllt und mittels Einbaus oder Aufstellung einer Heizungsanlage zum Zwecke der Inbetriebnahme in einem Gebäude durchgeführt wurde.
      (2) Hat der Vermieter die Miete in den letzten fünf Jahren bereits nach Absatz 1 oder nach § 559 oder § 559e erhöht, so mindern sich die Kosten, die nach Absatz 1 Satz 1 für die weitere Modernisierungsmaßnahme geltend gemacht werden können, um die Kosten, die in diesen früheren Verfahren für Modernisierungsmaßnahmen geltend gemacht wurden.
      (3) § 559b gilt für das vereinfachte Verfahren entsprechend. Der Vermieter muss in der Mieterhöhungserklärung angeben, dass er die Mieterhöhung nach dem vereinfachten Verfahren berechnet hat.
      (4) Hat der Vermieter eine Mieterhöhung im vereinfachten Verfahren geltend gemacht, so kann er innerhalb von fünf Jahren nach Zugang der Mieterhöhungserklärung beim Mieter keine Mieterhöhungen nach § 559 oder § 559e geltend machen. Dies gilt nicht,
      1. soweit der Vermieter in diesem Zeitraum Modernisierungsmaßnahmen auf Grund einer gesetzlichen Verpflichtung durchzuführen hat und er diese Verpflichtung bei Geltendmachung der Mieterhöhung im vereinfachten Verfahren nicht kannte oder kennen musste,
      2. sofern eine Modernisierungsmaßnahme auf Grund eines Beschlusses von Wohnungseigentümern durchgeführt wird, der frühestens zwei Jahre nach Zugang der Mieterhöhungserklärung beim Mieter gefasst wurde.
      (5) Für die Modernisierungsankündigung, die zu einer Mieterhöhung nach dem vereinfachten Verfahren führen soll, gilt § 555c mit den Maßgaben, dass
      1. der Vermieter in der Modernisierungsankündigung angeben muss, dass er von dem vereinfachten Verfahren Gebrauch macht,
      2. es der Angabe der voraussichtlichen künftigen Betriebskosten nach § 555c Absatz 1 Satz 2 Nummer 3 nicht bedarf.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559d Pflichtverletzungen bei Ankündigung oder Durchführung einer baulichen Veränderung',
    content: <<~LAW_TEXT
      Es wird vermutet, dass der Vermieter seine Pflichten aus dem Schuldverhältnis verletzt hat, wenn
      1. mit der baulichen Veränderung nicht innerhalb von zwölf Monaten nach deren angekündigtem Beginn oder, wenn Angaben hierzu nicht erfolgt sind, nach Zugang der Ankündigung der baulichen Veränderung begonnen wird,
      2. in der Ankündigung nach § 555c Absatz 1 ein Betrag für die zu erwartende Mieterhöhung angegeben wird, durch den die monatliche Miete mindestens verdoppelt würde,
      3. die bauliche Veränderung in einer Weise durchgeführt wird, die geeignet ist, zu erheblichen, objektiv nicht notwendigen Belastungen des Mieters zu führen, oder
      4. die Arbeiten nach Beginn der baulichen Veränderung mehr als zwölf Monate ruhen.
      Diese Vermutung gilt nicht, wenn der Vermieter darlegt, dass für das Verhalten im Einzelfall ein nachvollziehbarer objektiver Grund vorliegt.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559e Mieterhöhung nach Einbau oder Aufstellung einer Heizungsanlage',
    content: <<~LAW_TEXT
      (1) Hat der Vermieter Modernisierungsmaßnahmen nach § 555b Nummer 1a durchgeführt, welche die Voraussetzungen für Zuschüsse aus öffentlichen Haushalten dem Grunde nach erfüllen, und dabei Drittmittel nach § 559a in Anspruch genommen, so kann er die jährliche Miete um 10 Prozent der für die Wohnung aufgewendeten Kosten abzüglich der in Anspruch genommenen Drittmittel erhöhen. Wenn eine Förderung nicht erfolgt, obwohl die Voraussetzungen für eine Förderung dem Grunde nach erfüllt sind, kann der Vermieter die jährliche Miete nach Maßgabe des § 559 erhöhen.
      (2) § 559 Absatz 2 Satz 1 ist mit der Maßgabe anwendbar, dass Kosten, die für Erhaltungsmaßnahmen erforderlich gewesen wären, pauschal in Höhe von 15 Prozent nicht zu den aufgewendeten Kosten gehören. Dies gilt nicht, soweit Kosten durch den Einbau einer Heizungsanlage im Sinne des § 43 des Gebäudemodernisierungsgesetzes entstanden sind.
      (3) § 559 Absatz 3a Satz 1 ist mit der Maßgabe anwendbar, dass sich im Hinblick auf eine Modernisierungsmaßnahme nach § 555b Nummer 1a die monatliche Miete um nicht mehr als 0,50 Euro je Quadratmeter Wohnfläche innerhalb von sechs Jahren erhöhen darf. Ist der Vermieter daneben zu Mieterhöhungen nach § 559 Absatz 1 berechtigt, so dürfen die in § 559 Absatz 3a Satz 1 und 2 genannten Grenzen nicht überschritten werden.
      (4) § 559 Absatz 3, 4 und 5 sowie die §§ 559b bis 559d gelten entsprechend.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 559f Mieterhöhung nach Einbau oder Aufstellung einer Wärmepumpe',
    content: <<~LAW_TEXT
      (1) Der Vermieter kann beim Einbau oder bei der Aufstellung einer Wärmepumpe eine Mieterhöhung aufgrund einer Modernisierungsmaßnahme nach § 559 Absatz 1 oder § 559e Absatz 1 in voller Höhe nur verlangen, wenn er den Nachweis erbracht hat, dass die Jahresarbeitszahl der Wärmepumpe bei mindestens 2,5 liegt. Dieser Nachweis ist nicht erforderlich, wenn das Gebäude
      1. nach 1996 errichtet worden ist,
      2. mindestens nach den Vorgaben der Wärmeschutzverordnung vom 16. August 1994 (BGBl. I S. 2121) in der bis zum Ablauf des 31. Januar 2002 geltenden Fassung erbaut worden ist oder der Gebäudeeigentümer nachweist, dass der Jahres-Heizwärmebedarf die Anforderungen nach der Wärmeschutzverordnung vom 16. August 1994 (BGBl. I S. 2121) in der bis zum Ablauf des 31. Januar 2002 geltenden Fassung nicht überschreitet,
      3. nach einer Sanierung mindestens den Anforderungen des § 38 des Gebäudemodernisierungsgesetzes entspricht oder
      4. mit einer Vorlauftemperatur beheizt werden kann, die nicht mehr als 55 Grad Celsius bei lokaler Norm-Außentemperatur beträgt.
      Der Nachweis nach Satz 1 muss von einem Fachunternehmer erbracht werden. Die Ermittlung der Jahresarbeitszahl erfolgt auf der Grundlage der Richtlinie VDI 4650 Blatt 1 Berichtigung 2024-08 oder eines vergleichbaren Verfahrens in der Regel vor der Inbetriebnahme der Anlage und nicht anhand von den Werten im Betrieb.
      (2) Sofern der Nachweis nach Absatz 1 Satz 1 nicht erbracht wird, kann der Vermieter für eine Mieterhöhung nach § 559 Absatz 1 oder § 559e Absatz 1 nur die Hälfte der für die Wohnung aufgewendeten Kosten zugrunde legen.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 560 Veränderungen von Betriebskosten',
    content: <<~LAW_TEXT
      (1) Bei einer Betriebskostenpauschale ist der Vermieter berechtigt, Erhöhungen der Betriebskosten durch Erklärung in Textform anteilig auf den Mieter umzulegen, soweit dies im Mietvertrag vereinbart ist. Die Erklärung ist nur wirksam, wenn in ihr der Grund für die Umlage bezeichnet und erläutert wird.
      (2) Der Mieter schuldet den auf ihn entfallenden Teil der Umlage mit Beginn des auf die Erklärung folgenden übernächsten Monats. Soweit die Erklärung darauf beruht, dass sich die Betriebskosten rückwirkend erhöht haben, wirkt sie auf den Zeitpunkt der Erhöhung der Betriebskosten, höchstens jedoch auf den Beginn des der Erklärung vorausgehenden Kalenderjahres zurück, sofern der Vermieter die Erklärung innerhalb von drei Monaten nach Kenntnis von der Erhöhung abgibt.
      (3) Ermäßigen sich die Betriebskosten, so ist eine Betriebskostenpauschale vom Zeitpunkt der Ermäßigung an entsprechend herabzusetzen. Die Ermäßigung ist dem Mieter unverzüglich mitzuteilen.
      (4) Sind Betriebskostenvorauszahlungen vereinbart worden, so kann jede Vertragspartei nach einer Abrechnung durch Erklärung in Textform eine Anpassung auf eine angemessene Höhe vornehmen.
      (5) Bei Veränderungen von Betriebskosten ist der Grundsatz der Wirtschaftlichkeit zu beachten.
      (6) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nRegelungen über die Miethöhe",
    paragraph_title: '§ 561 Sonderkündigungsrecht des Mieters nach Mieterhöhung',
    content: <<~LAW_TEXT
      (1) Macht der Vermieter eine Mieterhöhung nach § 558 oder § 559 geltend, so kann der Mieter bis zum Ablauf des zweiten Monats nach dem Zugang der Erklärung des Vermieters das Mietverhältnis außerordentlich zum Ablauf des übernächsten Monats kündigen. Kündigt der Mieter, so tritt die Mieterhöhung nicht ein.
      (2) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 3\nPfandrecht des Vermieters",
    paragraph_title: '§ 562 Umfang des Vermieterpfandrechts',
    content: <<~LAW_TEXT
      (1) Der Vermieter hat für seine Forderungen aus dem Mietverhältnis ein Pfandrecht an den eingebrachten Sachen des Mieters. Es erstreckt sich nicht auf die Sachen, die der Pfändung nicht unterliegen.
      (2) Für künftige Entschädigungsforderungen und für die Miete für eine spätere Zeit als das laufende und das folgende Mietjahr kann das Pfandrecht nicht geltend gemacht werden.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 3\nPfandrecht des Vermieters",
    paragraph_title: '§ 562a Erlöschen des Vermieterpfandrechts',
    content: <<~LAW_TEXT
      Das Pfandrecht des Vermieters erlischt mit der Entfernung der Sachen von dem Grundstück, außer wenn diese ohne Wissen oder unter Widerspruch des Vermieters erfolgt. Der Vermieter kann nicht widersprechen, wenn sie den gewöhnlichen Lebensverhältnissen entspricht oder wenn die zurückbleibenden Sachen zur Sicherung des Vermieters offenbar ausreichen.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 3\nPfandrecht des Vermieters",
    paragraph_title: '§ 562b Selbsthilferecht, Herausgabeanspruch',
    content: <<~LAW_TEXT
      (1) Der Vermieter darf die Entfernung der Sachen, die seinem Pfandrecht unterliegen, auch ohne Anrufen des Gerichts verhindern, soweit er berechtigt ist, der Entfernung zu widersprechen. Wenn der Mieter auszieht, darf der Vermieter diese Sachen in seinen Besitz nehmen.
      (2) Sind die Sachen ohne Wissen oder unter Widerspruch des Vermieters entfernt worden, so kann er die Herausgabe zum Zwecke der Zurückschaffung auf das Grundstück und, wenn der Mieter ausgezogen ist, die Überlassung des Besitzes verlangen. Das Pfandrecht erlischt mit dem Ablauf eines Monats, nachdem der Vermieter von der Entfernung der Sachen Kenntnis erlangt hat, wenn er diesen Anspruch nicht vorher gerichtlich geltend gemacht hat.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 3\nPfandrecht des Vermieters",
    paragraph_title: '§ 562c Abwendung des Pfandrechts durch Sicherheitsleistung',
    content: <<~LAW_TEXT
      Der Mieter kann die Geltendmachung des Pfandrechts des Vermieters durch Sicherheitsleistung abwenden. Er kann jede einzelne Sache dadurch von dem Pfandrecht befreien, dass er in Höhe ihres Wertes Sicherheit leistet.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 3\nPfandrecht des Vermieters",
    paragraph_title: '§ 562d Pfändung durch Dritte',
    content: <<~LAW_TEXT
      Wird eine Sache, die dem Pfandrecht des Vermieters unterliegt, für einen anderen Gläubiger gepfändet, so kann diesem gegenüber das Pfandrecht nicht wegen der Miete für eine frühere Zeit als das letzte Jahr vor der Pfändung geltend gemacht werden.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 563 Eintrittsrecht bei Tod des Mieters',
    content: <<~LAW_TEXT
      (1) Der Ehegatte oder Lebenspartner, der mit dem Mieter einen gemeinsamen Haushalt führt, tritt mit dem Tod des Mieters in das Mietverhältnis ein.
      (2) Leben in dem gemeinsamen Haushalt Kinder des Mieters, treten diese mit dem Tod des Mieters in das Mietverhältnis ein, wenn nicht der Ehegatte oder Lebenspartner eintritt. Andere Familienangehörige, die mit dem Mieter einen gemeinsamen Haushalt führen, treten mit dem Tod des Mieters in das Mietverhältnis ein, wenn nicht der Ehegatte oder der Lebenspartner eintritt. Dasselbe gilt für Personen, die mit dem Mieter einen auf Dauer angelegten gemeinsamen Haushalt führen.
      (3) Erklären eingetretene Personen im Sinne des Absatzes 1 oder 2 innerhalb eines Monats, nachdem sie vom Tod des Mieters Kenntnis erlangt haben, dem Vermieter, dass sie das Mietverhältnis nicht fortsetzen wollen, gilt der Eintritt als nicht erfolgt. Für geschäftsunfähige oder in der Geschäftsfähigkeit beschränkte Personen gilt § 210 entsprechend. Sind mehrere Personen in das Mietverhältnis eingetreten, so kann jeder die Erklärung für sich abgeben.
      (4) Der Vermieter kann das Mietverhältnis innerhalb eines Monats, nachdem er von dem endgültigen Eintritt in das Mietverhältnis Kenntnis erlangt hat, außerordentlich mit der gesetzlichen Frist kündigen, wenn in der Person des Eingetretenen ein wichtiger Grund vorliegt.
      (5) Eine abweichende Vereinbarung zum Nachteil des Mieters oder solcher Personen, die nach Absatz 1 oder 2 eintrittsberechtigt sind, ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 563a Fortsetzung mit überlebenden Mietern',
    content: <<~LAW_TEXT
      (1) Sind mehrere Personen im Sinne des § 563 gemeinsam Mieter, so wird das Mietverhältnis beim Tod eines Mieters mit den überlebenden Mietern fortgesetzt.
      (2) Die überlebenden Mieter können das Mietverhältnis innerhalb eines Monats, nachdem sie vom Tod des Mieters Kenntnis erlangt haben, außerordentlich mit der gesetzlichen Frist kündigen.
      (3) Eine abweichende Vereinbarung zum Nachteil der Mieter ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 563b Haftung bei Eintritt oder Fortsetzung',
    content: <<~LAW_TEXT
      (1) Die Personen, die nach § 563 in das Mietverhältnis eingetreten sind oder mit denen es nach § 563a fortgesetzt wird, haften neben dem Erben für die bis zum Tod des Mieters entstandenen Verbindlichkeiten als Gesamtschuldner. Im Verhältnis zu diesen Personen haftet der Erbe allein, soweit nichts anderes bestimmt ist.
      (2) Hat der Mieter die Miete für einen nach seinem Tod liegenden Zeitraum im Voraus entrichtet, sind die Personen, die nach § 563 in das Mietverhältnis eingetreten sind oder mit denen es nach § 563a fortgesetzt wird, verpflichtet, dem Erben dasjenige herauszugeben, was sie infolge der Vorausentrichtung der Miete ersparen oder erlangen.
      (3) Der Vermieter kann, falls der verstorbene Mieter keine Sicherheit geleistet hat, von den Personen, die nach § 563 in das Mietverhältnis eingetreten sind oder mit denen es nach § 563a fortgesetzt wird, nach Maßgabe des § 551 eine Sicherheitsleistung verlangen.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 564 Fortsetzung des Mietverhältnisses mit dem Erben, außerordentliche Kündigung',
    content: <<~LAW_TEXT
      Treten beim Tod des Mieters keine Personen im Sinne des § 563 in das Mietverhältnis ein oder wird es nicht mit ihnen nach § 563a fortgesetzt, so wird es mit dem Erben fortgesetzt. In diesem Fall ist sowohl der Erbe als auch der Vermieter berechtigt, das Mietverhältnis innerhalb eines Monats außerordentlich mit der gesetzlichen Frist zu kündigen, nachdem sie vom Tod des Mieters und davon Kenntnis erlangt haben, dass ein Eintritt in das Mietverhältnis oder dessen Fortsetzung nicht erfolgt sind.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 565 Gewerbliche Weitervermietung',
    content: <<~LAW_TEXT
      (1) Soll der Mieter nach dem Mietvertrag den gemieteten Wohnraum gewerblich einem Dritten zu Wohnzwecken weitervermieten, so tritt der Vermieter bei der Beendigung des Mietverhältnisses in die Rechte und Pflichten aus dem Mietverhältnis zwischen dem Mieter und dem Dritten ein. Schließt der Vermieter erneut einen Mietvertrag zur gewerblichen Weitervermietung ab, so tritt der Mieter anstelle der bisherigen Vertragspartei in die Rechte und Pflichten aus dem Mietverhältnis mit dem Dritten ein.
      (2) Die §§ 566a bis 566e gelten entsprechend.
      (3) Eine zum Nachteil des Dritten abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566 Kauf bricht nicht Miete',
    content: <<~LAW_TEXT
      (1) Wird der vermietete Wohnraum nach der Überlassung an den Mieter von dem Vermieter an einen Dritten veräußert, so tritt der Erwerber anstelle des Vermieters in die sich während der Dauer seines Eigentums aus dem Mietverhältnis ergebenden Rechte und Pflichten ein.
      (2) Erfüllt der Erwerber die Pflichten nicht, so haftet der Vermieter für den von dem Erwerber zu ersetzenden Schaden wie ein Bürge, der auf die Einrede der Vorausklage verzichtet hat. Erlangt der Mieter von dem Übergang des Eigentums durch Mitteilung des Vermieters Kenntnis, so wird der Vermieter von der Haftung befreit, wenn nicht der Mieter das Mietverhältnis zum ersten Termin kündigt, zu dem die Kündigung zulässig ist.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566a Mietsicherheit',
    content: <<~LAW_TEXT
      Hat der Mieter des veräußerten Wohnraums dem Vermieter für die Erfüllung seiner Pflichten Sicherheit geleistet, so tritt der Erwerber in die dadurch begründeten Rechte und Pflichten ein. Kann bei Beendigung des Mietverhältnisses der Mieter die Sicherheit von dem Erwerber nicht erlangen, so ist der Vermieter weiterhin zur Rückgewähr verpflichtet.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566b Vorausverfügung über die Miete',
    content: <<~LAW_TEXT
      (1) Hat der Vermieter vor dem Übergang des Eigentums über die Miete verfügt, die auf die Zeit der Berechtigung des Erwerbers entfällt, so ist die Verfügung wirksam, soweit sie sich auf die Miete für den zur Zeit des Eigentumsübergangs laufenden Kalendermonat bezieht. Geht das Eigentum nach dem 15. Tag des Monats über, so ist die Verfügung auch wirksam, soweit sie sich auf die Miete für den folgenden Kalendermonat bezieht.
      (2) Eine Verfügung über die Miete für eine spätere Zeit muss der Erwerber gegen sich gelten lassen, wenn er sie zur Zeit des Übergangs des Eigentums kennt.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566c Vereinbarung zwischen Mieter und Vermieter über die Miete',
    content: <<~LAW_TEXT
      Ein Rechtsgeschäft, das zwischen dem Mieter und dem Vermieter über die Mietforderung vorgenommen wird, insbesondere die Entrichtung der Miete, ist dem Erwerber gegenüber wirksam, soweit es sich nicht auf die Miete für eine spätere Zeit als den Kalendermonat bezieht, in welchem der Mieter von dem Übergang des Eigentums Kenntnis erlangt. Erlangt der Mieter die Kenntnis nach dem 15. Tag des Monats, so ist das Rechtsgeschäft auch wirksam, soweit es sich auf die Miete für den folgenden Kalendermonat bezieht. Ein Rechtsgeschäft, das nach dem Übergang des Eigentums vorgenommen wird, ist jedoch unwirksam, wenn der Mieter bei der Vornahme des Rechtsgeschäfts von dem Übergang des Eigentums Kenntnis hat.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566d Aufrechnung durch den Mieter',
    content: <<~LAW_TEXT
      Soweit die Entrichtung der Miete an den Vermieter nach § 566c dem Erwerber gegenüber wirksam ist, kann der Mieter gegen die Mietforderung des Erwerbers eine ihm gegen den Vermieter zustehende Forderung aufrechnen. Die Aufrechnung ist ausgeschlossen, wenn der Mieter die Gegenforderung erworben hat, nachdem er von dem Übergang des Eigentums Kenntnis erlangt hat, oder wenn die Gegenforderung erst nach der Erlangung der Kenntnis und später als die Miete fällig geworden ist.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 566e Mitteilung des Eigentumsübergangs durch den Vermieter',
    content: <<~LAW_TEXT
      (1) Teilt der Vermieter dem Mieter mit, dass er das Eigentum an dem vermieteten Wohnraum auf einen Dritten übertragen hat, so muss er in Ansehung der Mietforderung dem Mieter gegenüber die mitgeteilte Übertragung gegen sich gelten lassen, auch wenn sie nicht erfolgt oder nicht wirksam ist.
      (2) Die Mitteilung kann nur mit Zustimmung desjenigen zurückgenommen werden, der als der neue Eigentümer bezeichnet worden ist.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 567 Belastung des Wohnraums durch den Vermieter',
    content: <<~LAW_TEXT
      Wird der vermietete Wohnraum nach der Überlassung an den Mieter von dem Vermieter mit dem Recht eines Dritten belastet, so sind die §§ 566 bis 566e entsprechend anzuwenden, wenn durch die Ausübung des Rechts dem Mieter der vertragsgemäße Gebrauch entzogen wird. Wird der Mieter durch die Ausübung des Rechts in dem vertragsgemäßen Gebrauch beschränkt, so ist der Dritte dem Mieter gegenüber verpflichtet, die Ausübung zu unterlassen, soweit sie den vertragsgemäßen Gebrauch beeinträchtigen würde.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 567a Veräußerung oder Belastung vor der Überlassung des Wohnraums',
    content: <<~LAW_TEXT
      Hat vor der Überlassung des vermieteten Wohnraums an den Mieter der Vermieter den Wohnraum an einen Dritten veräußert oder mit einem Recht belastet, durch dessen Ausübung der vertragsgemäße Gebrauch dem Mieter entzogen oder beschränkt wird, so gilt das Gleiche wie in den Fällen des § 566 Abs. 1 und des § 567, wenn der Erwerber dem Vermieter gegenüber die Erfüllung der sich aus dem Mietverhältnis ergebenden Pflichten übernommen hat.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 4\nWechsel der Vertragsparteien",
    paragraph_title: '§ 567b Weiterveräußerung oder Belastung durch Erwerber',
    content: <<~LAW_TEXT
      Wird der vermietete Wohnraum von dem Erwerber weiterveräußert oder belastet, so sind § 566 Abs. 1 und die §§ 566a bis 567a entsprechend anzuwenden. Erfüllt der neue Erwerber die sich aus dem Mietverhältnis ergebenden Pflichten nicht, so haftet der Vermieter dem Mieter nach § 566 Abs. 2.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 568 Form und Inhalt der Kündigung',
    content: <<~LAW_TEXT
      (1) Die Kündigung des Mietverhältnisses bedarf der schriftlichen Form.
      (2) Der Vermieter soll den Mieter auf die Möglichkeit, die Form und die Frist des Widerspruchs nach den §§ 574 bis 574b rechtzeitig hinweisen.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 569 Außerordentliche fristlose Kündigung aus wichtigem Grund',
    content: <<~LAW_TEXT
      (1) Ein wichtiger Grund im Sinne des § 543 Abs. 1 liegt für den Mieter auch vor, wenn der gemietete Wohnraum so beschaffen ist, dass seine Benutzung mit einer erheblichen Gefährdung der Gesundheit verbunden ist. Dies gilt auch, wenn der Mieter die Gefahr bringende Beschaffenheit bei Vertragsschluss gekannt oder darauf verzichtet hat, die ihm wegen dieser Beschaffenheit zustehenden Rechte geltend zu machen.
      (2) Ein wichtiger Grund im Sinne des § 543 Abs. 1 liegt ferner vor, wenn eine Vertragspartei den Hausfrieden nachhaltig stört, so dass dem Kündigenden unter Berücksichtigung aller Umstände des Einzelfalls, insbesondere eines Verschuldens der Vertragsparteien, und unter Abwägung der beiderseitigen Interessen die Fortsetzung des Mietverhältnisses bis zum Ablauf der Kündigungsfrist oder bis zur sonstigen Beendigung des Mietverhältnisses nicht zugemutet werden kann.
      (2a) Ein wichtiger Grund im Sinne des § 543 Absatz 1 liegt ferner vor, wenn der Mieter mit einer Sicherheitsleistung nach § 551 in Höhe eines Betrages im Verzug ist, der der zweifachen Monatsmiete entspricht. Die als Pauschale oder als Vorauszahlung ausgewiesenen Betriebskosten sind bei der Berechnung der Monatsmiete nach Satz 1 nicht zu berücksichtigen. Einer Abhilfefrist oder einer Abmahnung nach § 543 Absatz 3 Satz 1 bedarf es nicht. Absatz 3 Nummer 2 Satz 1 sowie § 543 Absatz 2 Satz 2 sind entsprechend anzuwenden.
      (3) Ergänzend zu § 543 Abs. 2 Satz 1 Nr. 3 gilt:
      1. Im Falle des § 543 Abs. 2 Satz 1 Nr. 3 Buchstabe a ist der rückständige Teil der Miete nur dann als nicht unerheblich anzusehen, wenn er die Miete für einen Monat übersteigt. Dies gilt nicht, wenn der Wohnraum nur zum vorübergehenden Gebrauch vermietet ist.
      2. Die Kündigung wird auch dann unwirksam, wenn der Vermieter spätestens bis zum Ablauf von zwei Monaten nach Eintritt der Rechtshängigkeit des Räumungsanspruchs hinsichtlich der fälligen Miete und der fälligen Entschädigung nach § 546a Abs. 1 befriedigt wird oder sich eine öffentliche Stelle zur Befriedigung verpflichtet. Dies gilt nicht, wenn der Kündigung vor nicht länger als zwei Jahren bereits eine nach Satz 1 unwirksam gewordene Kündigung vorausgegangen ist.
      3. Ist der Mieter rechtskräftig zur Zahlung einer erhöhten Miete nach den §§ 558 bis 560 verurteilt worden, so kann der Vermieter das Mietverhältnis wegen Zahlungsverzugs des Mieters nicht vor Ablauf von zwei Monaten nach rechtskräftiger Verurteilung kündigen, wenn nicht die Voraussetzungen der außerordentlichen fristlosen Kündigung schon wegen der bisher geschuldeten Miete erfüllt sind.
      (4) Der zur Kündigung führende wichtige Grund ist in dem Kündigungsschreiben anzugeben.
      (5) Eine Vereinbarung, die zum Nachteil des Mieters von den Absätzen 1 bis 3 dieser Vorschrift oder von § 543 abweicht, ist unwirksam. Ferner ist eine Vereinbarung unwirksam, nach der der Vermieter berechtigt sein soll, aus anderen als den im Gesetz zugelassenen Gründen außerordentlich fristlos zu kündigen.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 570 Ausschluss des Zurückbehaltungsrechts',
    content: <<~LAW_TEXT
      Dem Mieter steht kein Zurückbehaltungsrecht gegen den Rückgabeanspruch des Vermieters zu.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 571 Weiterer Schadensersatz bei verspäteter Rückgabe von Wohnraum',
    content: <<~LAW_TEXT
      (1) Gibt der Mieter den gemieteten Wohnraum nach Beendigung des Mietverhältnisses nicht zurück, so kann der Vermieter einen weiteren Schaden im Sinne des § 546a Abs. 2 nur geltend machen, wenn die Rückgabe infolge von Umständen unterblieben ist, die der Mieter zu vertreten hat. Der Schaden ist nur insoweit zu ersetzen, als die Billigkeit eine Schadloshaltung erfordert. Dies gilt nicht, wenn der Mieter gekündigt hat.
      (2) Wird dem Mieter nach § 721 oder § 794a der Zivilprozessordnung eine Räumungsfrist gewährt, so ist er für die Zeit von der Beendigung des Mietverhältnisses bis zum Ablauf der Räumungsfrist zum Ersatz eines weiteren Schadens nicht verpflichtet.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 1\nAllgemeine Vorschriften",
    paragraph_title: '§ 572 Vereinbartes Rücktrittsrecht; Mietverhältnis unter auflösender Bedingung',
    content: <<~LAW_TEXT
      (1) Auf eine Vereinbarung, nach der der Vermieter berechtigt sein soll, nach Überlassung des Wohnraums an den Mieter vom Vertrag zurückzutreten, kann der Vermieter sich nicht berufen.
      (2) Ferner kann der Vermieter sich nicht auf eine Vereinbarung berufen, nach der das Mietverhältnis zum Nachteil des Mieters auflösend bedingt ist.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 573 Ordentliche Kündigung des Vermieters',
    content: <<~LAW_TEXT
      (1) Der Vermieter kann nur kündigen, wenn er ein berechtigtes Interesse an der Beendigung des Mietverhältnisses hat. Die Kündigung zum Zwecke der Mieterhöhung ist ausgeschlossen.
      (2) Ein berechtigtes Interesse des Vermieters an der Beendigung des Mietverhältnisses liegt insbesondere vor, wenn
      1. der Mieter seine vertraglichen Pflichten schuldhaft nicht unerheblich verletzt hat,
      2. der Vermieter die Räume als Wohnung für sich, seine Familienangehörigen oder Angehörige seines Haushalts benötigt oder
      3. der Vermieter durch die Fortsetzung des Mietverhältnisses an einer angemessenen wirtschaftlichen Verwertung des Grundstücks gehindert und dadurch erhebliche Nachteile erleiden würde; die Möglichkeit, durch eine anderweitige Vermietung als Wohnraum eine höhere Miete zu erzielen, bleibt außer Betracht; der Vermieter kann sich auch nicht darauf berufen, dass er die Mieträume im Zusammenhang mit einer beabsichtigten oder nach Überlassung an den Mieter erfolgten Begründung von Wohnungseigentum veräußern will.
      (3) Die Gründe für ein berechtigtes Interesse des Vermieters sind in dem Kündigungsschreiben anzugeben. Andere Gründe werden nur berücksichtigt, soweit sie nachträglich entstanden sind.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 573a Erleichterte Kündigung des Vermieters',
    content: <<~LAW_TEXT
      (1) Ein Mietverhältnis über eine Wohnung in einem vom Vermieter selbst bewohnten Gebäude mit nicht mehr als zwei Wohnungen kann der Vermieter auch kündigen, ohne dass es eines berechtigten Interesses im Sinne des § 573 bedarf. Die Kündigungsfrist verlängert sich in diesem Fall um drei Monate.
      (2) Absatz 1 gilt entsprechend für Wohnraum innerhalb der vom Vermieter selbst bewohnten Wohnung, sofern der Wohnraum nicht nach § 549 Abs. 2 Nr. 2 vom Mieterschutz ausgenommen ist.
      (3) In dem Kündigungsschreiben ist anzugeben, dass die Kündigung auf die Voraussetzungen des Absatzes 1 oder 2 gestützt wird.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 573b Teilkündigung des Vermieters',
    content: <<~LAW_TEXT
      (1) Der Vermieter kann nicht zum Wohnen bestimmte Nebenräume oder Teile eines Grundstücks ohne ein berechtigtes Interesse im Sinne des § 573 kündigen, wenn er die Kündigung auf diese Räume oder Grundstücksteile beschränkt und sie dazu verwenden will,
      1. Wohnraum zum Zwecke der Vermietung zu schaffen oder
      2. den neu zu schaffenden und den vorhandenen Wohnraum mit Nebenräumen oder Grundstücksteilen auszustatten.
      (2) Die Kündigung ist spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats zulässig.
      (3) Verzögert sich der Beginn der Bauarbeiten, so kann der Mieter eine Verlängerung des Mietverhältnisses um einen entsprechenden Zeitraum verlangen.
      (4) Der Mieter kann eine angemessene Senkung der Miete verlangen.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 573c Fristen der ordentlichen Kündigung',
    content: <<~LAW_TEXT
      (1) Die Kündigung ist spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats zulässig. Die Kündigungsfrist für den Vermieter verlängert sich nach fünf und acht Jahren seit der Überlassung des Wohnraums um jeweils drei Monate.
      (2) Bei Wohnraum, der nur zum vorübergehenden Gebrauch vermietet worden ist, kann eine kürzere Kündigungsfrist vereinbart werden.
      (3) Bei Wohnraum nach § 549 Abs. 2 Nr. 2 ist die Kündigung spätestens am 15. eines Monats zum Ablauf dieses Monats zulässig.
      (4) Eine zum Nachteil des Mieters von Absatz 1 oder 3 abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 573d Außerordentliche Kündigung mit gesetzlicher Frist',
    content: <<~LAW_TEXT
      (1) Kann ein Mietverhältnis außerordentlich mit der gesetzlichen Frist gekündigt werden, so gelten mit Ausnahme der Kündigung gegenüber Erben des Mieters nach § 564 die §§ 573 und 573a entsprechend.
      (2) Die Kündigung ist spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats zulässig, bei Wohnraum nach § 549 Abs. 2 Nr. 2 spätestens am 15. eines Monats zum Ablauf dieses Monats (gesetzliche Frist). § 573a Abs. 1 Satz 2 findet keine Anwendung.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 574 Widerspruch des Mieters gegen die Kündigung',
    content: <<~LAW_TEXT
      (1) Der Mieter kann der Kündigung des Vermieters widersprechen und von ihm die Fortsetzung des Mietverhältnisses verlangen, wenn die Beendigung des Mietverhältnisses für den Mieter, seine Familie oder einen anderen Angehörigen seines Haushalts eine Härte bedeuten würde, die auch unter Würdigung der berechtigten Interessen des Vermieters nicht zu rechtfertigen ist. Dies gilt nicht, wenn ein Grund vorliegt, der den Vermieter zur außerordentlichen fristlosen Kündigung berechtigt.
      (2) Eine Härte liegt auch vor, wenn angemessener Ersatzwohnraum zu zumutbaren Bedingungen nicht beschafft werden kann.
      (3) Bei der Würdigung der berechtigten Interessen des Vermieters werden nur die in dem Kündigungsschreiben nach § 573 Abs. 3 angegebenen Gründe berücksichtigt, außer wenn die Gründe nachträglich entstanden sind.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 574a Fortsetzung des Mietverhältnisses nach Widerspruch',
    content: <<~LAW_TEXT
      (1) Im Falle des § 574 kann der Mieter verlangen, dass das Mietverhältnis so lange fortgesetzt wird, wie dies unter Berücksichtigung aller Umstände angemessen ist. Ist dem Vermieter nicht zuzumuten, das Mietverhältnis zu den bisherigen Vertragsbedingungen fortzusetzen, so kann der Mieter nur verlangen, dass es unter einer angemessenen Änderung der Bedingungen fortgesetzt wird.
      (2) Kommt keine Einigung zustande, so werden die Fortsetzung des Mietverhältnisses, deren Dauer sowie die Bedingungen, zu denen es fortgesetzt wird, durch Urteil bestimmt. Ist ungewiss, wann voraussichtlich die Umstände wegfallen, auf Grund derer die Beendigung des Mietverhältnisses eine Härte bedeutet, so kann bestimmt werden, dass das Mietverhältnis auf unbestimmte Zeit fortgesetzt wird.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 574b Form und Frist des Widerspruchs',
    content: <<~LAW_TEXT
      (1) Der Widerspruch des Mieters gegen die Kündigung ist in Textform zu erklären. Auf Verlangen des Vermieters soll der Mieter über die Gründe des Widerspruchs unverzüglich Auskunft erteilen.
      (2) Der Vermieter kann die Fortsetzung des Mietverhältnisses ablehnen, wenn der Mieter ihm den Widerspruch nicht spätestens zwei Monate vor der Beendigung des Mietverhältnisses erklärt hat. Hat der Vermieter nicht rechtzeitig vor Ablauf der Widerspruchsfrist auf die Möglichkeit des Widerspruchs sowie auf dessen Form und Frist hingewiesen, so kann der Mieter den Widerspruch noch im ersten Termin des Räumungsrechtsstreits erklären.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 2\nMietverhältnisse auf unbestimmte Zeit",
    paragraph_title: '§ 574c Weitere Fortsetzung des Mietverhältnisses bei unvorhergesehenen Umständen',
    content: <<~LAW_TEXT
      (1) Ist auf Grund der §§ 574 bis 574b durch Einigung oder Urteil bestimmt worden, dass das Mietverhältnis auf bestimmte Zeit fortgesetzt wird, so kann der Mieter dessen weitere Fortsetzung nur verlangen, wenn dies durch eine wesentliche Änderung der Umstände gerechtfertigt ist oder wenn Umstände nicht eingetreten sind, deren vorgesehener Eintritt für die Zeitdauer der Fortsetzung bestimmend gewesen war.
      (2) Kündigt der Vermieter ein Mietverhältnis, dessen Fortsetzung auf unbestimmte Zeit durch Urteil bestimmt worden ist, so kann der Mieter der Kündigung widersprechen und vom Vermieter verlangen, das Mietverhältnis auf unbestimmte Zeit fortzusetzen. Haben sich die Umstände verändert, die für die Fortsetzung bestimmend gewesen waren, so kann der Mieter eine Fortsetzung des Mietverhältnisses nur nach § 574 verlangen; unerhebliche Veränderungen bleiben außer Betracht.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 3\nMietverhältnisse auf bestimmte Zeit",
    paragraph_title: '§ 575 Zeitmietvertrag',
    content: <<~LAW_TEXT
      (1) Ein Mietverhältnis kann auf bestimmte Zeit eingegangen werden, wenn der Vermieter nach Ablauf der Mietzeit
      1. die Räume als Wohnung für sich, seine Familienangehörigen oder Angehörige seines Haushalts nutzen will,
      2. in zulässiger Weise die Räume beseitigen oder so wesentlich verändern oder instand setzen will, dass die Maßnahmen durch eine Fortsetzung des Mietverhältnisses erheblich erschwert würden, oder
      3. die Räume an einen zur Dienstleistung Verpflichteten vermieten will
      und er dem Mieter den Grund der Befristung bei Vertragsschluss schriftlich mitteilt. Anderenfalls gilt das Mietverhältnis als auf unbestimmte Zeit abgeschlossen.
      (2) Der Mieter kann vom Vermieter frühestens vier Monate vor Ablauf der Befristung verlangen, dass dieser ihm binnen eines Monats mitteilt, ob der Befristungsgrund noch besteht. Erfolgt die Mitteilung später, so kann der Mieter eine Verlängerung des Mietverhältnisses um den Zeitraum der Verspätung verlangen.
      (3) Tritt der Grund der Befristung erst später ein, so kann der Mieter eine Verlängerung des Mietverhältnisses um einen entsprechenden Zeitraum verlangen. Entfällt der Grund, so kann der Mieter eine Verlängerung auf unbestimmte Zeit verlangen. Die Beweislast für den Eintritt des Befristungsgrundes und die Dauer der Verzögerung trifft den Vermieter.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 3\nMietverhältnisse auf bestimmte Zeit",
    paragraph_title: '§ 575a Außerordentliche Kündigung mit gesetzlicher Frist',
    content: <<~LAW_TEXT
      (1) Kann ein Mietverhältnis, das auf bestimmte Zeit eingegangen ist, außerordentlich mit der gesetzlichen Frist gekündigt werden, so gelten mit Ausnahme der Kündigung gegenüber Erben des Mieters nach § 564 die §§ 573 und 573a entsprechend.
      (2) Die §§ 574 bis 574c gelten entsprechend mit der Maßgabe, dass die Fortsetzung des Mietverhältnisses höchstens bis zum vertraglich bestimmten Zeitpunkt der Beendigung verlangt werden kann.
      (3) Die Kündigung ist spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats zulässig, bei Wohnraum nach § 549 Abs. 2 Nr. 2 spätestens am 15. eines Monats zum Ablauf dieses Monats (gesetzliche Frist). § 573a Abs. 1 Satz 2 findet keine Anwendung.
      (4) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 4\nWerkwohnungen",
    paragraph_title: '§ 576 Fristen der ordentlichen Kündigung bei Werkmietwohnungen',
    content: <<~LAW_TEXT
      (1) Ist Wohnraum mit Rücksicht auf das Bestehen eines Dienstverhältnisses vermietet, so kann der Vermieter nach Beendigung des Dienstverhältnisses abweichend von § 573c Abs. 1 Satz 2 mit folgenden Fristen kündigen:
      1. bei Wohnraum, der dem Mieter weniger als zehn Jahre überlassen war, spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats, wenn der Wohnraum für einen anderen zur Dienstleistung Verpflichteten benötigt wird;
      2. spätestens am dritten Werktag eines Kalendermonats zum Ablauf dieses Monats, wenn das Dienstverhältnis seiner Art nach die Überlassung von Wohnraum erfordert hat, der in unmittelbarer Beziehung oder Nähe zur Arbeitsstätte steht, und der Wohnraum aus dem gleichen Grund für einen anderen zur Dienstleistung Verpflichteten benötigt wird.
      (2) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 4\nWerkwohnungen",
    paragraph_title: '§ 576a Besonderheiten des Widerspruchsrechts bei Werkmietwohnungen',
    content: <<~LAW_TEXT
      (1) Bei der Anwendung der §§ 574 bis 574c auf Werkmietwohnungen sind auch die Belange des Dienstberechtigten zu berücksichtigen.
      (2) Die §§ 574 bis 574c gelten nicht, wenn
      1. der Vermieter nach § 576 Abs. 1 Nr. 2 gekündigt hat;
      2. der Mieter das Dienstverhältnis gelöst hat, ohne dass ihm von dem Dienstberechtigten gesetzlich begründeter Anlass dazu gegeben war, oder der Mieter durch sein Verhalten dem Dienstberechtigten gesetzlich begründeten Anlass zur Auflösung des Dienstverhältnisses gegeben hat.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Unterkapitel 4\nWerkwohnungen",
    paragraph_title: '§ 576b Entsprechende Geltung des Mietrechts bei Werkdienstwohnungen',
    content: <<~LAW_TEXT
      (1) Ist Wohnraum im Rahmen eines Dienstverhältnisses überlassen, so gelten für die Beendigung des Rechtsverhältnisses hinsichtlich des Wohnraums die Vorschriften über Mietverhältnisse entsprechend, wenn der zur Dienstleistung Verpflichtete den Wohnraum überwiegend mit Einrichtungsgegenständen ausgestattet hat oder in dem Wohnraum mit seiner Familie oder Personen lebt, mit denen er einen auf Dauer angelegten gemeinsamen Haushalt führt.
      (2) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 6\nBesonderheiten bei der Bildung von Wohnungseigentum an vermieteten Wohnungen",
    paragraph_title: '§ 577 Vorkaufsrecht des Mieters',
    content: <<~LAW_TEXT
      (1) Werden vermietete Wohnräume, an denen nach der Überlassung an den Mieter Wohnungseigentum begründet worden ist oder begründet werden soll, an einen Dritten verkauft, so ist der Mieter zum Vorkauf berechtigt. Dies gilt nicht, wenn der Vermieter die Wohnräume an einen Familienangehörigen oder an einen Angehörigen seines Haushalts verkauft. Soweit sich nicht aus den nachfolgenden Absätzen etwas anderes ergibt, finden auf das Vorkaufsrecht die Vorschriften über den Vorkauf Anwendung.
      (2) Die Mitteilung des Verkäufers oder des Dritten über den Inhalt des Kaufvertrags ist mit einer Unterrichtung des Mieters über sein Vorkaufsrecht zu verbinden.
      (3) Die Ausübung des Vorkaufsrechts erfolgt durch schriftliche Erklärung des Mieters gegenüber dem Verkäufer.
      (4) Stirbt der Mieter, so geht das Vorkaufsrecht auf diejenigen über, die in das Mietverhältnis nach § 563 Abs. 1 oder 2 eintreten.
      (5) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Kapitel 6\nBesonderheiten bei der Bildung von Wohnungseigentum an vermieteten Wohnungen",
    paragraph_title: '§ 577a Kündigungsbeschränkung bei Wohnungsumwandlung',
    content: <<~LAW_TEXT
      (1) Ist an vermieteten Wohnräumen nach der Überlassung an den Mieter Wohnungseigentum begründet und das Wohnungseigentum veräußert worden, so kann sich ein Erwerber auf berechtigte Interessen im Sinne des § 573 Abs. 2 Nr. 2 oder 3 erst nach Ablauf von drei Jahren seit der Veräußerung berufen.
      (1a) Die Kündigungsbeschränkung nach Absatz 1 gilt entsprechend, wenn vermieteter Wohnraum nach der Überlassung an den Mieter
      1. an eine Personengesellschaft oder an mehrere Erwerber veräußert worden ist oder
      2. zu Gunsten einer Personengesellschaft oder mehrerer Erwerber mit einem Recht belastet worden ist, durch dessen Ausübung dem Mieter der vertragsgemäße Gebrauch entzogen wird.
      Satz 1 ist nicht anzuwenden, wenn die Gesellschafter oder Erwerber derselben Familie oder demselben Haushalt angehören oder vor Überlassung des Wohnraums an den Mieter Wohnungseigentum begründet worden ist.
      (2) Die Frist nach Absatz 1 oder nach Absatz 1a beträgt bis zu zehn Jahre, wenn die ausreichende Versorgung der Bevölkerung mit Mietwohnungen zu angemessenen Bedingungen in einer Gemeinde oder einem Teil einer Gemeinde besonders gefährdet ist und diese Gebiete nach Satz 2 bestimmt sind. Die Landesregierungen werden ermächtigt, diese Gebiete und die Frist nach Satz 1 durch Rechtsverordnung für die Dauer von jeweils höchstens zehn Jahren zu bestimmen.
      (2a) Wird nach einer Veräußerung oder Belastung im Sinne des Absatzes 1a Wohnungseigentum begründet, so beginnt die Frist, innerhalb der eine Kündigung nach § 573 Absatz 2 Nummer 2 oder 3 ausgeschlossen ist, bereits mit der Veräußerung oder Belastung nach Absatz 1a.
      (3) Eine zum Nachteil des Mieters abweichende Vereinbarung ist unwirksam.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 578 Mietverhältnisse über Grundstücke und Räume',
    content: <<~LAW_TEXT
      (1) Auf Mietverhältnisse über Grundstücke sind die Vorschriften der §§ 554, 562 bis 562d, 566 bis 567b sowie 570 entsprechend anzuwenden. § 550 ist mit der Maßgabe anzuwenden, dass ein Mietvertrag, der für längere Zeit als ein Jahr nicht in Textform geschlossen wird, für unbestimmte Zeit gilt.
      (2) Auf Mietverhältnisse über Räume, die keine Wohnräume sind, sind die in Absatz 1 genannten Vorschriften sowie § 552 Abs. 1, § 555a Absatz 1 bis 3, §§ 555b, 555c Absatz 1 bis 4, § 555d Absatz 1 bis 6, § 555e Absatz 1 und 2, § 555f und § 569 Abs. 2 entsprechend anzuwenden. § 556c Absatz 1 und 2 sowie die auf Grund des § 556c Absatz 3 erlassene Rechtsverordnung sind entsprechend anzuwenden, abweichende Vereinbarungen sind zulässig. Sind die Räume zum Aufenthalt von Menschen bestimmt, so gilt außerdem § 569 Abs. 1 entsprechend.
      (3) Auf Verträge über die Anmietung von Räumen durch eine juristische Person des öffentlichen Rechts oder einen anerkannten privaten Träger der Wohlfahrtspflege, die geschlossen werden, um die Räume Personen mit dringendem Wohnungsbedarf zum Wohnen zu überlassen, sind die in den Absätzen 1 und 2 genannten Vorschriften sowie die §§ 557, 557a Absatz 1 bis 3 und 5, § 557b Absatz 1 bis 3 und 5, die §§ 558 bis 559d, 561, 568 Absatz 1, § 569 Absatz 3 bis 5, die §§ 573 bis 573d, 575, 575a Absatz 1, 3 und 4, die §§ 577 und 577a entsprechend anzuwenden. Solche Verträge können zusätzlich zu den in § 575 Absatz 1 Satz 1 genannten Gründen auch dann auf bestimmte Zeit geschlossen werden, wenn der Vermieter die Räume nach Ablauf der Mietzeit für ihm obliegende oder ihm übertragene öffentliche Aufgaben nutzen will.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 578a Mietverhältnisse über eingetragene Schiffe',
    content: <<~LAW_TEXT
      (1) Die Vorschriften der §§ 566, 566a, 566e bis 567b gelten im Falle der Veräußerung oder Belastung eines im Schiffsregister eingetragenen Schiffs entsprechend.
      (2) Eine Verfügung, die der Vermieter vor dem Übergang des Eigentums über die Miete getroffen hat, die auf die Zeit der Berechtigung des Erwerbers entfällt, ist dem Erwerber gegenüber wirksam. Das Gleiche gilt für ein Rechtsgeschäft, das zwischen dem Mieter und dem Vermieter über die Mietforderung vorgenommen wird, insbesondere die Entrichtung der Miete; ein Rechtsgeschäft, das nach dem Übergang des Eigentums vorgenommen wird, ist jedoch unwirksam, wenn der Mieter bei der Vornahme des Rechtsgeschäfts von dem Übergang des Eigentums Kenntnis hat. § 566d gilt entsprechend.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 578b Verträge über die Miete digitaler Produkte',
    content: <<~LAW_TEXT
      (1) Auf einen Verbrauchervertrag, bei dem der Unternehmer sich verpflichtet, dem Verbraucher digitale Produkte zu vermieten, sind die folgenden Vorschriften nicht anzuwenden:
      1. § 535 Absatz 1 Satz 2 und die §§ 536 bis 536d über die Rechte bei Mängeln und
      2. § 543 Absatz 2 Satz 1 Nummer 1 und Absatz 4 über die Rechte bei unterbliebener Bereitstellung.
      An die Stelle der nach Satz 1 nicht anzuwendenden Vorschriften treten die Vorschriften des Abschnitts 3 Titel 2a. Der Anwendungsausschluss nach Satz 1 Nummer 2 gilt nicht, wenn der Vertrag die Bereitstellung eines körperlichen Datenträgers zum Gegenstand hat, der ausschließlich als Träger digitaler Inhalte dient.
      (2) Wenn der Verbraucher einen Verbrauchervertrag nach Absatz 1 wegen unterbliebener Bereitstellung (§ 327c), Mangelhaftigkeit (§ 327m) oder Änderung (§ 327r Absatz 3 und 4) des digitalen Produkts beendet, sind die §§ 546 bis 548 nicht anzuwenden. An die Stelle der nach Satz 1 nicht anzuwendenden Vorschriften treten die Vorschriften des Abschnitts 3 Titel 2a.
      (3) Für einen Verbrauchervertrag, bei dem der Unternehmer sich verpflichtet, dem Verbraucher eine Sache zu vermieten, die ein digitales Produkt enthält oder mit ihm verbunden ist, gelten die Anwendungsausschlüsse nach den Absätzen 1 und 2 entsprechend für diejenigen Bestandteile des Vertrags, die das digitale Produkt betreffen.
      (4) Auf einen Vertrag zwischen Unternehmern, der der Bereitstellung digitaler Produkte gemäß eines Verbrauchervertrags nach Absatz 1 oder Absatz 3 dient, ist § 536a Absatz 2 über den Anspruch des Unternehmers gegen den Vertriebspartner auf Ersatz von denjenigen Aufwendungen nicht anzuwenden, die er im Verhältnis zum Verbraucher nach § 327l zu tragen hatte. An die Stelle des nach Satz 1 nicht anzuwendenden § 536a Absatz 2 treten die Vorschriften des Abschnitts 3 Titel 2a Untertitel 2.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 579 Fälligkeit der Miete',
    content: <<~LAW_TEXT
      (1) Die Miete für ein Grundstück und für bewegliche Sachen ist am Ende der Mietzeit zu entrichten. Ist die Miete nach Zeitabschnitten bemessen, so ist sie nach Ablauf der einzelnen Zeitabschnitte zu entrichten. Die Miete für ein Grundstück ist, sofern sie nicht nach kürzeren Zeitabschnitten bemessen ist, jeweils nach Ablauf eines Kalendervierteljahrs am ersten Werktag des folgenden Monats zu entrichten.
      (2) Für Mietverhältnisse über Räume gilt § 556b Abs. 1 entsprechend.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 580 Außerordentliche Kündigung bei Tod des Mieters',
    content: <<~LAW_TEXT
      Stirbt der Mieter, so ist sowohl der Erbe als auch der Vermieter berechtigt, das Mietverhältnis innerhalb eines Monats, nachdem sie vom Tod des Mieters Kenntnis erlangt haben, außerordentlich mit der gesetzlichen Frist zu kündigen.
    LAW_TEXT
  },
  {
    subtitle: "Untertitel 3\nMietverhältnisse über andere Sachen und digitale Produkte",
    paragraph_title: '§ 580a Kündigungsfristen',
    content: <<~LAW_TEXT
      (1) Bei einem Mietverhältnis über Grundstücke, über Räume, die keine Geschäftsräume sind, ist die ordentliche Kündigung zulässig,
      1. wenn die Miete nach Tagen bemessen ist, an jedem Tag zum Ablauf des folgenden Tages;
      2. wenn die Miete nach Wochen bemessen ist, spätestens am ersten Werktag einer Woche zum Ablauf des folgenden Sonnabends;
      3. wenn die Miete nach Monaten oder längeren Zeitabschnitten bemessen ist, spätestens am dritten Werktag eines Kalendermonats zum Ablauf des übernächsten Monats, bei einem Mietverhältnis über gewerblich genutzte unbebaute Grundstücke jedoch nur zum Ablauf eines Kalendervierteljahrs.
      (2) Bei einem Mietverhältnis über Geschäftsräume ist die ordentliche Kündigung spätestens am dritten Werktag eines Kalendervierteljahres zum Ablauf des nächsten Kalendervierteljahrs zulässig.
      (3) Bei einem Mietverhältnis über bewegliche Sachen oder digitale Produkte ist die ordentliche Kündigung zulässig,
      1. wenn die Miete nach Tagen bemessen ist, an jedem Tag zum Ablauf des folgenden Tages;
      2. wenn die Miete nach längeren Zeitabschnitten bemessen ist, spätestens am dritten Tag vor dem Tag, mit dessen Ablauf das Mietverhältnis enden soll.
      Die Vorschriften über die Beendigung von Verbraucherverträgen über digitale Produkte bleiben unberührt.
      (4) Absatz 1 Nr. 3, Absatz 2 und 3 Nr. 2 sind auch anzuwenden, wenn ein Mietverhältnis außerordentlich mit der gesetzlichen Frist gekündigt werden kann.
    LAW_TEXT
  },
]

law_texts_data.each do |law_text_data|
  LawText.find_or_create_by!(paragraph_title: law_text_data[:paragraph_title]) do |law_text|
    law_text.subtitle = law_text_data[:subtitle]
    law_text.content = law_text_data[:content].strip
  end
end

puts "➔ #{LawText.count} law texts created\n\n"
puts "-------------------------"
puts "-------------------------"
puts "-------------------------"
puts "-------------------------"
puts "To see things in the seed, that is genius 🌱 — Lao Tzu"
