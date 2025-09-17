# TODO for Adding Request Approval and Approval Status Sections

## Steps to Complete


- [x] Edit `lib/widgets/student_drawer.dart` to add two new menu items: "Request Approval" and "Approval Status" with appropriate icons and navigation callbacks.
- [x] Create `lib/pages/request_approval_page.dart`:
  - Implement a page with a dropdown for categories (Certifications, Achievements, Internships, Research papers, Projects, Workshops).
  - Add form fields: Title (TextField), Description (TextField), PDF Upload (File picker), and for research papers/projects, an additional Link field (TextField).
  - Add submit button with logic to handle auto-acceptance for Certifications and Workshops, set others to Pending, and update the approval status list.
- [x] Create `lib/pages/approval_status_page.dart`:
  - Implement a page with three tabs: Accepted, Rejected, Pending.
  - Each tab displays a list of approval requests.
  - For Rejected items, add an info icon that shows a dialog with the rejection reason.
- [x] Implement state management for approval requests (e.g., a list of maps with title, description, category, status, reason).
- [x] Test navigation from drawer to new pages, form submission, and status display.
- [x] Ensure the app builds and runs without errors.

