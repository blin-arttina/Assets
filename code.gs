function onFormSubmit(e) {
  const submittedData = e.values;

  // Extract fields based on your form structure
  const timestamp = submittedData[0];
  const name = submittedData[1];
  const email = submittedData[2];
  const walletAddress = submittedData[3];

  // Copy to beta_test sheet
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const backupSheet = ss.getSheetByName('beta_test');
  backupSheet.appendRow(submittedData);

  // Prepare and send welcome email
  const subject = "Thank you for being a tester!";
  const body = "Hi " + name + ",\n\nThank you for being a tester. We hope you refer your friends and family.\n\nAny comments, questions, or suggestions for new ideas please email us at Tina nort66@gmail.com.\n\nBest,\nThe Assets Alert Team";

  MailApp.sendEmail(email, subject, body);
}
