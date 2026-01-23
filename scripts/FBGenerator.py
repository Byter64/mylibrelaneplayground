import argparse
from pathlib import Path
import shutil

scriptPath = Path(__file__).resolve()

codeTemplate = """RM_IHPSG13_2P_1024x16_c2_bm_bist sram0 (
    .A_CLK  (clkA),
    .A_MEN  (1'b1),
    .A_WEN  (writeEnableA & (addressA[16:10] == 0)),
    .A_REN  (!writeEnableA & (addressA[16:10] == 0)),
    .A_ADDR (addressA[9:0]),
    .A_DIN  (dataInA),
    .A_DLY  (1'b1), // tie high!
    .A_DOUT (dataOutA),
    .A_BM   ({16{1'b1}}),

    .B_CLK  (clkB),
    .B_MEN  (1'b1),
    .B_WEN  (writeEnableB & (addressB[16:10] == 0)),
    .B_REN  (!writeEnableB & (addressB[16:10] == 0)),
    .B_ADDR (addressB[9:0]),
    .B_DIN  (dataInB),
    .B_DLY  (1'b1), // tie high!
    .B_DOUT (dataOutB),
    .B_BM   ({16{1'b1}}),

    // Built-in self test port
    .A_BIST_CLK   ('0),
    .A_BIST_EN    ('0),
    .A_BIST_MEN   ('0),
    .A_BIST_WEN   ('0),
    .A_BIST_REN   ('0),
    .A_BIST_ADDR  ('0),
    .A_BIST_DIN   ('0),
    .A_BIST_BM    ('0),

    .B_BIST_CLK   ('0),
    .B_BIST_EN    ('0),
    .B_BIST_MEN   ('0),
    .B_BIST_WEN   ('0),
    .B_BIST_REN   ('0),
    .B_BIST_ADDR  ('0),
    .B_BIST_DIN   ('0),
    .B_BIST_BM    ('0)
);""".splitlines()


def parseArgs():
	parser = argparse.ArgumentParser(
		description="Generate the framebuffer and place it in src directory."
	)
	parser.add_argument("-c", "--count", type=int, required=True, help="Number of SRAM blocks to generate in the framebuffer.")

	return parser.parse_args()

def generateOutMuxer(instanceNumber, lines):
	insertIndex = -1
	for(i, line) in enumerate(lines):
		if ");" in line:
			insertIndex = i + 2
			break
	signalTemplate = "logic[15:0] dataOutA0; logic[15:0] dataOutB0;\n"
	muxTemplate = "\t\t\t\t(addressA[16:10] == 0) ? dataOutA0 :\n"

	for i in range(instanceNumber):
		lines.insert(insertIndex, signalTemplate.replace("A0", f"A{i}").replace("B0", f"B{i}"))
		insertIndex += 1
	
	lines.insert(insertIndex, "\n")
	insertIndex += 1

	lines.insert(insertIndex, "assign dataOutA = \n")
	insertIndex += 1

	for i in range(instanceNumber):
		lines.insert(insertIndex, muxTemplate.replace("A0", f"A{i}").replace("== 0", f"== {i}"))
		insertIndex += 1

	lines.insert(insertIndex, "\t\t\t\t16'h0000;\n\n")
	insertIndex += 1

	lines.insert(insertIndex, "assign dataOutB = \n")
	insertIndex += 1

	for i in range(instanceNumber):
		lines.insert(insertIndex, muxTemplate.replace("A0", f"B{i}").replace("== 0", f"== {i}"))
		insertIndex += 1

	lines.insert(insertIndex, "\t\t\t\t16'h0000;\n\n")



def generateSRAMInstance(instanceNumber, lines):
	insertIndex = -1
	for(i, line) in enumerate(lines):
		if ");" in line:
			insertIndex = i + 2
			break

	for i in range(instanceNumber):
		instanceCode = codeTemplate.copy()
		instanceCode[0] = instanceCode[0].replace("sram0", f"sram{i}")
		instanceCode[3] = instanceCode[3].replace("== 0", f"== {i}")
		instanceCode[4] = instanceCode[4].replace("== 0", f"== {i}")
		instanceCode[8] = instanceCode[8].replace("dataOutA", f"dataOutA{i}")

		instanceCode[13] = instanceCode[13].replace("== 0", f"== {i}")
		instanceCode[14] = instanceCode[14].replace("== 0", f"== {i}")
		instanceCode[18] = instanceCode[18].replace("dataOutB", f"dataOutB{i}")

		for(j, line) in enumerate(instanceCode):
			lines.insert(insertIndex, instanceCode[j] + "\n")
			insertIndex += 1
		lines.insert(insertIndex, "\n")
		insertIndex += 1

def main():
	global scriptPath
	global codeTemplate

	args = parseArgs()
	count = args.count

	#Delete old file
	generatedFramebufferPath = scriptPath.parent.parent / "src" / "Framebuffer.v"
	generatedFramebufferPath.unlink(missing_ok=True)

	#Copy the template file
	templatePath = scriptPath.parent / "Framebuffer.v"
	shutil.copy(templatePath, generatedFramebufferPath)

	file = open(generatedFramebufferPath, "r+")
	lines = file.readlines()
	generateSRAMInstance(count, lines)
	generateOutMuxer(count, lines)

	file.seek(0)
	file.writelines(lines)
	file.close()


if __name__ == "__main__":
	main()