RSpec::Matchers.define :object_having do |expected_klass, expected_attributes|
  match do |actual_object|
    expect(actual_object).to be_a(expected_klass)
    expected_attributes.each do |method, expected_value|
      expect(actual_object).to respond_to(method)
      actual_value = actual_object.public_send(method)
      expect(actual_value).to eq(expected_value)
    end
  end
end
