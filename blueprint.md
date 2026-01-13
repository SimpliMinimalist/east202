# Project Blueprint

## Overview

A Flutter application for managing products and orders.

## Project Structure

The project follows a feature-based folder structure.

-   `lib/features/auth`: Authentication-related features.
-   `lib/features/orders`: Order management features.
    -   `lib/features/orders/search_orders`: Search functionality for orders.
-   `lib/features/profile`: User profile management.
-   `lib/features/store`: Store management features.
    -   `lib/features/store/add_product`: Feature for adding and editing products.
    -   `lib/features/store/providers`: Contains providers for the store feature.
    -   `lib/features/store/search_product`: Feature for searching products.
    -   `lib/features/store/store_setup`: Feature for setting up the store.

## Features Implemented

### Add/Edit Product Screen
-   Allows creating and editing products.
-   Image picker for adding up to 10 product images.
-   Fields for product name, price, category, stock, and description.
-   Character limit for product name and description fields is only shown on focus.
-   Ability to add product variants.
-   "Add Product Variants" button width is now based on its content and centered.
-   The icon for the "Add Product Variants" button changes from an add icon to an edit icon when variants are present.
-   Draft saving functionality.
-   Sale price functionality with a dedicated bottom sheet widget (`SalePriceBottomSheet`).
-   Display of the original price with a strikethrough when a sale price is active.
-   The strikethrough line and the text color for the original price are now the same.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.
-   Sale price input validation to ensure the sale price is less than the original price.
-   The "Done" button in the sale price bottom sheet is disabled if the validation fails.
-   The sale price is automatically cleared if the bottom sheet is dismissed with an invalid value.
-   The sale price bottom sheet is scroll-controlled to avoid keyboard overlap.
-   Corrected a typo from `_editedDitedProduct` to `_editedProduct`.

### Edit Variant Screen
-   Reuses the `PriceInputField` from the add product screen, allowing for sale prices on individual variants.
-   Manages state for sale price, including the discount percentage calculation.
-   Uses the `SalePriceBottomSheet` for a consistent editing experience.

### Add Variants Screen
- Added a "Demo" button to the bottom of the screen, replicating the exact style and position of the "Add Product" button for demonstration purposes.

### Variant List UI
-   Removed the shadow effect from the variant cards in the product details screen.
-   Added a light border to maintain visual separation between the cards.
-   Displays the variant's image in the list.
-   **Displays the sale price, original price with strikethrough, and discount percentage in the `VariantsList` widget when a sale price is active.**

### Category Field UI Fix
-   Corrected the height and alignment of the "Category" input field to match other text fields and ensure it expands dynamically as category chips are added.
-   Replaced the previous implementation with a `TextFormField` wrapped in a `GestureDetector` and an `AbsorbPointer`.
-   The `TextFormField` is set to `readOnly: true` and acts as a styled container.
-   The `Wrap` widget containing the category `Chip`s is placed inside the `prefixIcon` property of the `InputDecoration`.
-   Fixed a typo from `Listile` to `ListTile` in the category picker bottom sheet.

### Category Chip UI
-   Reduced the height of the category chips to make them more compact.

### Variant Image Picker
-   Allows users to add an image to each product variant.
-   Refactored `ProductImageHandler` to support a variable number of images.
-   Updated the `maxImages` for the main product to 10 and for variants to 4.
-   Integrated into `EditVariantScreen` to allow picking up to 4 images for a variant.

## Current Change: Add Demo Button

-   **Goal:** Add a demo button to the Add Variants screen.
-   **Steps:**
    1.  **Update `add_variants_screen.dart`:** Added a bottom navigation bar with an `ElevatedButton` styled exactly like the one on the "Add Product" screen.
    2.  **Update `blueprint.md`:** Document the new demo button.
    3.  **Commit and Push:** Commit all changes to the repository.
