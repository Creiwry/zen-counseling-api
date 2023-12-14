require "rails_helper"

RSpec.describe MessageRecipientsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/message_recipients").to route_to("message_recipients#index")
    end

    it "routes to #show" do
      expect(get: "/message_recipients/1").to route_to("message_recipients#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/message_recipients").to route_to("message_recipients#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/message_recipients/1").to route_to("message_recipients#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/message_recipients/1").to route_to("message_recipients#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/message_recipients/1").to route_to("message_recipients#destroy", id: "1")
    end
  end
end
