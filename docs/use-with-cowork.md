# Use with a cowork assistant

A cowork assistant works on folders that you share with it.

1. Share two folders with it: specforge and the folder of your design. If
   it accepts only one folder, make a parent folder that holds both, or
   upload `specforge-<version>.zip` and let it extract the zip next to the
   design.
2. Paste:

   ```text
   Read START-HERE.md in the specforge folder and follow it.
   Approach: design-info. The design information is in <folder>.
   Create the project in <folder>/spec. Ask me before you write the document.
   ```

   For RTL write `Approach: rtl. The RTL is in <folder>, top module <name>.`
3. Answer its questions and approve the outline.
4. The build depends on the assistant:

   - It can run commands and `doctor --build` succeeds there: it builds.
   - It cannot: it writes all files, and you build on your computer:

     ```powershell
     & "D:\specforge\specforge.cmd" build "D:\designs\fifo\spec" --figures
     ```

     Give the messages and the PDF back to it for the final check.

Check in advance that your organization allows the design to be given to
that AI service.
