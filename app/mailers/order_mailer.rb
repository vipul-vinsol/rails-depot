class OrderMailer < ApplicationMailer
  default from: 'Vipul Bhardwaj <vipul@vinsol.com>'

  def received(order)
    @order = order
    @order.line_item.product.product_images.attached? && @order.line_items.each do |line_item|
      first_image, remaining_images = line_item.product.product_images
      attachments.inline[image.filename] = first_image.download
      remaining_images.each do |image|
        attachments[image.filename] = image.download 
      end
    end
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid
    I18n.with_locale(@order.user.language) do
      mail to: order.email, subject: t('.subject')
    end
  end

  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end