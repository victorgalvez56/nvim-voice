import Image from "next/image";

export default function Footer() {
  return (
    <footer className="px-6 py-10 border-t border-zinc-800/50">
      <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <Image src="/logo.png" alt="NvimVoice" width={28} height={28} className="rounded-lg" />
          <span className="text-sm font-medium text-zinc-400">NvimVoice</span>
        </div>
        <div className="flex items-center gap-4 text-sm text-zinc-500">
          <span>Built by Victor Galvez</span>
          <a
            href="https://github.com/victorgalvez56/nvim-voice"
            className="hover:text-zinc-300 transition-colors"
          >
            GitHub
          </a>
          <a
            href="https://www.linkedin.com/in/victor-galvez-dev/"
            className="hover:text-zinc-300 transition-colors"
            target="_blank"
            rel="noopener noreferrer"
          >
            LinkedIn
          </a>
          <a
            href="https://buymeacoffee.com/victorgalvez"
            className="hover:text-zinc-300 transition-colors"
            target="_blank"
            rel="noopener noreferrer"
          >
            Buy me a coffee
          </a>
          <span>MIT License</span>
        </div>
      </div>
    </footer>
  );
}
