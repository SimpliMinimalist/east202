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

### Variant List UI
-   Removed the shadow effect from the variant cards in the product details screen.
-   Added a light border to maintain visual separation between the cards.

## Current Change: Category Field UI Fix

-   **Goal:** Correct the height and alignment of the "Category" input field to match other text fields and ensure it expands dynamically as category chips are added.
-   **Steps:**
    1.  Identified that `InputDecorator` and `SizedBox` did not provide the desired dynamic behavior and consistent styling.
    2.  Replaced the previous implementation with a `TextFormField` wrapped in a `GestureDetector` and an `AbsorbPointer`.
    3.  The `TextFormField` is set to `readOnly: true` and acts as a perfectly styled container, inheriting the correct height, border, and label behavior from the app's theme.
    4.  The `Wrap` widget containing the category `Chip`s is placed inside the `prefixIcon` property of the `InputDecoration`.
    5.  A space character is used in the `TextEditingController` when categories are present to ensure the `prefixIcon` is displayed correctly and the field can expand vertically.
    6.  Fixed a typo from `Listile` to `ListTile` in the category picker bottom sheet.
