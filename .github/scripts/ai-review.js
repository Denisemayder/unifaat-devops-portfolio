const fs = require("fs");

const diffFile = process.env.DIFF_FILE || "/tmp/pr-diff.txt";
const reportFile = "/tmp/ai-review-report.md";

if (!fs.existsSync(diffFile)) {
  console.error("Arquivo de diff não encontrado.");
  process.exit(1);
}

const diff = fs.readFileSync(diffFile, "utf8");
const findings = [];

const rules = [
  {
    severity: "CRITICAL",
    name: "Possível senha ou token exposto",
    regex: /\b(password|passwd|secret|api[_-]?key|access[_-]?token)\s*[:=]\s*["'][^"']{4,}["']/i
  },
  {
    severity: "CRITICAL",
    name: "Uso de eval()",
    regex: /\beval\s*\(/
  },
  {
    severity: "CRITICAL",
    name: "Possível SQL Injection",
    regex: /\b(query|execute)\s*\(\s*`[^`]*\$\{/i
  },
  {
    severity: "WARNING",
    name: "Uso de console.log",
    regex: /\bconsole\.log\s*\(/
  },
  {
    severity: "WARNING",
    name: "Bloco catch vazio",
    regex: /\bcatch\s*(?:\([^)]*\))?\s*\{\s*\}/
  },
  {
    severity: "WARNING",
    name: "Servidor escutando em 0.0.0.0",
    regex: /(?:listen|host|bind)[^\n]*0\.0\.0\.0/i
  },
  {
    severity: "INFO",
    name: "Comentário TODO ou FIXME",
    regex: /\b(TODO|FIXME)\b/i
  }
];

let currentFile = "";
let lineNumber = 0;

for (const line of diff.split("\n")) {
  if (line.startsWith("+++ b/")) {
    currentFile = line.slice(6);
    continue;
  }

  const hunk = line.match(/^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@/);

  if (hunk) {
    lineNumber = Number(hunk[1]);
    continue;
  }

  if (line.startsWith("+") && !line.startsWith("+++")) {
    const code = line.slice(1);

    for (const rule of rules) {
      if (rule.regex.test(code)) {
        findings.push({
          severity: rule.severity,
          name: rule.name,
          file: currentFile,
          line: lineNumber
        });
      }
    }

    lineNumber++;
  } else if (line.startsWith(" ") && !line.startsWith("+++")) {
    lineNumber++;
  }
}

let report = "## 🤖 Revisão Automática de Código\n\n";

if (findings.length === 0) {
  report += "✅ Nenhum problema identificado pelas regras configuradas.\n";
} else {
  report += "| Severidade | Problema | Arquivo | Linha |\n";
  report += "|---|---|---|---|\n";

  for (const finding of findings) {
    report += `| ${finding.severity} | ${finding.name} | ${finding.file} | ${finding.line} |\n`;
  }
}

const criticalCount = findings.filter(
  (finding) => finding.severity === "CRITICAL"
).length;

report += `\n**Total de problemas:** ${findings.length}\n`;
report += `\n**Problemas críticos:** ${criticalCount}\n`;
report += "\n_Análise automatizada por regras. Não substitui revisão humana._\n";

fs.writeFileSync(reportFile, report);

console.log(report);

if (criticalCount > 0) {
  console.error("⛔ Quality Gate reprovado: problemas CRITICAL encontrados.");
  process.exit(1);
}

console.log("✅ Quality Gate aprovado.");
