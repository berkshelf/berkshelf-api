shared_examples_for "a human-readable string" do
  it "does not start with Ruby object notation" do
    expect(subject.to_s).to_not start_with("#<")
  end

  it "does not contain a hex prefix" do
    expect(subject.to_s).to_not match(%r{0x[0-9a-f]+})
  end
end
