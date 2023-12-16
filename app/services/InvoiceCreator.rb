# frozen_string_literal: true

module InvoiceCreator
  def create_invoice_pdf(invoice)
    pdf = WickedPdf.new.pdf_from_string(%(
      <body>
        <style>
        body {
          padding: 14px;
          text-align: center;
        }

        table {
          width: 100%;
          margin: 20px auto;
          table-layout: auto;
        }
        table,
        td,
        th {
          border-collapse: collapse;
        }

        th,
        td {
          padding: 10px;
          border: solid 1px;
          text-align: center;
        }
        </style>
        <h1>Invoice</h1>
        <p>Therapist: #{invoice.admin.first_name} #{invoice.admin.last_name}</p>
        <p>Client name: #{invoice.client.first_name} #{invoice.client.last_name}</p>
        <table id="invoice-id">
          <thead>
            <th>Invoice number</th>
            <th>Date</th>
          </thead>
          <tbody>
            <tr>
              <td>#{invoice.id}</td>
              <td>#{invoice.created_at.strftime('%a, %d %b %Y')}</td>
            </tr>
          </tbody>
        </table>
        <table id="invoice-details">
          <thead>
            <th>Description</th>
            <th>Amount</th>
          </thead>
          <tbody>
            <tr>
              <td>Appointment number: #{invoice.appointment_number}</td>
              <td>$ #{invoice.total}</td>
            </tr>
          </tbody>
        </table>
      </body>
      ))
    invoice.document.attach(
      io: StringIO.new(pdf),
      filename: "invoice-#{invoice.id}.pdf",
      content_type: 'application/pdf'
    )
  end
end
