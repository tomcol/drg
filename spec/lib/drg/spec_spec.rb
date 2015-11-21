require 'spec_helper'

describe DRG::Spec do
  let(:file) { FIXTURE_ROOT.join('report') }

  subject { described_class.new file }

  describe '.generate' do
    it 'returns the spec for the given file as an array of lines' do
      expect(described_class.generate(file).join("\n")).to eq <<-RUBY
describe Report do
  let(:message) {}

  subject { described_class.new message }

  describe ".enqueue" do
    context "unless verification_code" do
      before {}
      it "returns nil" do
      end
    end

    context "if verification_code" do
      before {}
    end

  end

  describe ".process" do
  end

  describe ".replace" do
  end

  describe "#initialize" do
  end

  describe "#map_args" do
    context "unless val" do
      before {}
      it "returns list" do
      end
    end

    context "if val" do
      before {}
    end

  end

  describe "#call" do
    context "unless message[:verification_code_id]" do
      before {}
      it "returns []" do
      end
    end

    context "if message[:verification_code_id]" do
      before {}
    end

    context "duder = (1 == 2)" do
      before {}
      it "(0)" do
      end
    end

    context "not duder = (1 == 2)" do
      before {}
    end

    context "if report.save then" do
      before {}
      context "if user.wants_mail?" do
        before {}
        it "UserMailer.spam(user).deliver_now" do
        end
      end

      context "if not user.wants_mail?" do
        before {}
      end

    end

    context "if not report.save then" do
      before {}
    end

  end

  describe "#report" do
  end

  describe "#verification_code" do
  end

end
RUBY
    end
  end

  describe '#const' do
    it 'returns the Ruby constant defined in the given file' do
      expect(subject.const).to eq Report
    end
  end

  describe '#name' do
    it 'returns the name of the Ruby class in the given file' do
      expect(subject.name).to eq 'Report'
    end
  end

  describe '#funcs' do
    it 'returns an array with all the methods defined in the target file' do
      expect(subject.funcs).to be_a Array
      expect(subject.funcs.length).to eq 10
      expect(subject.funcs.select(&:class?).length).to eq 3
      expect(subject.funcs.reject(&:class?).length).to eq 7
      expect(subject.funcs.select(&:private?).length).to eq 2
      expect(subject.funcs.first.name).to eq :enqueue
      expect(subject.funcs.first.conditions.map(&:statement)).to eq ["return unless verification_code"]
    end
  end

  # describe 'collect_contexts' do
  #   context 'when there is only one condition' do
  #     let(:condition) { subject.func_by_name(:enqueue).conditions.first }
  #
  #     it 'returns a single element array containing the context' do
  #       expect(subject.collect_contexts(condition)).to eq ["context \"unless verification_code\" do", "  before {}",
  #                                                          "  it \"return\" do", "  end", "end"]
  #     end
  #   end
  #
  #   context 'when there is a nested condition' do
  #     let(:condition) { subject.func_by_name(:call).conditions[2] }
  #
  #     it 'returns a list of all the conditions with the correct nesting' do
  #       expect(subject.collect_contexts(condition)).to eq ["context \"if report.save then\" do", "  before {}",
  #                                                          "  context \"if user.wants_mail?\" do", "    before {}",
  #                                                          "    it \"UserMailer.spam(user).deliver_now\" do", "    end",
  #                                                          "  end", "end"]
  #     end
  #   end
  # end

  describe '#initialization_args' do
    it 'returns a list of args to initialize the class' do
      expect(subject.initialization_args).to eq [:message]
    end

    context 'when the subject takes multiple args' do
      let(:file) { FIXTURE_ROOT.join('multiple_args.rb') }

      it 'returns all the args' do
        expect(subject.initialization_args).to eq [:name, :age, :"*args"]
      end
    end

    context 'when the subject takes no args' do
      let(:file) { FIXTURE_ROOT.join('controllers/reservations_controller.rb') }

      it 'returns an empty array' do
        expect(subject.initialization_args).to eq []
      end
    end
  end

  describe '#class?' do
    context 'when the subject is a class' do
      it 'returns true' do
        expect(subject).to be_class
      end
    end

    context 'when the subject is a module' do
      let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

      it 'returns false' do
        expect(subject).to_not be_class
      end
    end
  end

  describe '#module?' do
    context 'when the subject is a module' do
      let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

      it 'returns true' do
        expect(subject).to be_module
      end
    end

    context 'when the subject is a class' do
      it 'returns false' do
        expect(subject).to_not be_module
      end
    end
  end

end
