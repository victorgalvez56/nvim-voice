import type { Metadata } from "next";
import { Inter, JetBrains_Mono } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const jetbrainsMono = JetBrains_Mono({
  variable: "--font-jetbrains",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "NvimVoice — Control Neovim with Your Voice",
  description:
    "A macOS menu bar app that translates voice commands into Neovim keybindings using local Whisper transcription and GPT-4 Vision.",
  icons: {
    icon: [
      { url: "/favicon-32x32.png", sizes: "32x32", type: "image/png" },
      { url: "/favicon-16x16.png", sizes: "16x16", type: "image/png" },
    ],
    apple: "/apple-touch-icon.png",
  },
  openGraph: {
    title: "NvimVoice — Control Neovim with Your Voice",
    description:
      "Speak your intent, get the exact Vim keystrokes. Local transcription, visual context, floating overlay.",
    type: "website",
    locale: "en_US",
    siteName: "NvimVoice",
  },
  twitter: {
    card: "summary_large_image",
    title: "NvimVoice — Control Neovim with Your Voice",
    description:
      "Speak your intent, get the exact Vim keystrokes. Local transcription, visual context, floating overlay.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <body
        className={`${inter.variable} ${jetbrainsMono.variable} antialiased`}
      >
        <div className="fixed inset-0 -z-10 bg-brand-dark">
          <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[600px] rounded-full bg-brand-purple/10 blur-[120px]" />
        </div>
        {children}
      </body>
    </html>
  );
}
