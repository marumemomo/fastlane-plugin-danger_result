describe Fastlane::Actions::DangerResultAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The danger_result plugin is working!")

      Fastlane::Actions::DangerResultAction.run(nil)
    end
  end
end
