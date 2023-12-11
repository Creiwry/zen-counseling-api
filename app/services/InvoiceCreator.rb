module InvoiceCreator
  def create_invoice_pdf(invoice) 
    pdf = WickedPdf.new.pdf_from_string(%Q(
      <h1>Hello there!</h1>
      <p>Number of appointments: #{invoice.appointment_number}</p>
      <p>Therapist: #{invoice.admin.email}</p>
      <p>Client name: #{invoice.client.email}</p>
      <p>Total price: $ #{invoice.total}</p>
      ))
    invoice.document.attach(
      io: StringIO.new(pdf),
      filename: "invoice-#{invoice.id}.pdf",
      content_type: 'application/pdf'
    )
  end
end
