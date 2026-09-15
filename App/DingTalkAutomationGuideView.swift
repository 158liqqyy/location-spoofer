import SwiftUI
import UIKit
import AppIntents

/// A small, system-owned setup bridge for DingTalk attendance automations.
/// iOS does not expose a public API for silently creating personal automations,
/// so the app opens Shortcuts and leaves the final trigger/action confirmation
/// to the user.
struct DingTalkAutomationGuideSection: View {
    @State private var isGuidePresented = false

    var body: some View {
        Section("钉钉考勤") {
            Button {
                isGuidePresented = true
            } label: {
                Label("设置钉钉考勤自动化", systemImage: "calendar.badge.clock")
            }
        }
        .sheet(isPresented: $isGuidePresented) {
            DingTalkAutomationGuideView()
        }
    }
}

struct DingTalkAutomationGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var openFailureMessage = ""

    private let steps = [
        "打开“快捷指令”后，进入“自动化”并新建个人自动化。",
        "选择“特定时间”，设置打卡时间和重复周期。",
        "继续后选择“立即运行”，不要勾选“运行时通知”。",
        "添加动作时选择“钉钉”，再选择“考勤打卡”。",
        "点击“下一步”并检查动作内容，最后点击“完成”。"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("系统快捷指令设置", systemImage: "checklist")
                            .font(.headline)
                        Text("App 不能代替系统创建个人自动化。下面的入口会打开快捷指令，按步骤完成一次设置即可。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text(String(index + 1))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 26, height: 26)
                                    .background(Color.blue, in: Circle())
                                Text(step)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    shortcutsEntry
                        .frame(maxWidth: .infinity)

                    Text("是否能在锁屏状态下完成钉钉打卡，取决于 iOS、钉钉版本、企业考勤策略和设备解锁状态。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .navigationTitle("钉钉考勤自动化")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
        .alert("无法打开快捷指令", isPresented: Binding(
            get: { !openFailureMessage.isEmpty },
            set: { if !$0 { openFailureMessage = "" } }
        )) {
            Button("知道了", role: .cancel) {}
        } message: {
            Text(openFailureMessage)
        }
    }

    @ViewBuilder
    private var shortcutsEntry: some View {
        if #available(iOS 16.0, *) {
            VStack(spacing: 10) {
                ShortcutsLink {
                    dismiss()
                }
                .shortcutsLinkStyle(.automatic)

                Button {
                    openShortcutsHome()
                } label: {
                    Label("打开快捷指令 App", systemImage: "arrow.up.forward.app")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        } else {
            Button {
                openShortcutsHome()
            } label: {
                Label("打开快捷指令 App", systemImage: "arrow.up.forward.app")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func openShortcutsHome() {
        guard let url = URL(string: "shortcuts://") else { return }
        UIApplication.shared.open(url, options: [:]) { opened in
            guard !opened else { return }
            Task { @MainActor in
                openFailureMessage = "请确认系统已安装“快捷指令”App，然后从主屏幕手动打开。"
            }
        }
    }
}
