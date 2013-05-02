require "spec_helper"

describe EmailValidator do
  describe "#validate_each" do
    let(:record){ double() }
    let(:error_array){ double() }
    let(:attribute_errors){ double() }
    let(:attribute){ :email }
    let(:validator){ described_class.new({ :attributes => [attribute] }) }
    before { record.stub(:errors){ error_array } }
    before { error_array.stub(:[]).with(attribute){ attribute_errors } }

    context "passed an invalid email address" do
      it "adds an error to the attribute errors array" do
        attribute_errors.should_receive(:<<).with("Sorry, this is not a valid email address")
        validator.validate_each(record, attribute, "invalid-email-address")
      end
    end

    context "passed a valid email address" do
      it "does not add an error to the attribute errors array" do
        attribute_errors.should_not_receive(:<<)
        validator.validate_each(record, attribute, "valid@email.address")
      end
    end
  end
end